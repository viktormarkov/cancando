RSpec.describe Cancando do
  class TestClass
    include Cancando
  end

  let(:subject) { TestClass.new }

  describe 'ability merging' do
    context 'same condition for one action' do
      before do
        subject.can_do(:index, :user, business_id: 2)
        subject.can_do(:index, :user, business_id: 3)
      end

      it 'should merge all conditions into one' do
        expect(subject).to receive(:can).with([:index], :user, { :business_id => [2, 3] })
        subject.apply
      end
    end

    context 'different actions with same conditions' do
      before do
        subject.can_do(:index, :user, business_id: 1)
        subject.can_do(:show, :user, business_id: 1)
      end

      it 'should merge actions' do
        expect(subject).to receive(:can).with([:index, :show], :user, { :business_id => 1 })
        subject.apply
      end
    end

    context 'several abilities' do
      before do
        subject.can_do(:index, :user, id: 1)
        subject.can_do(:index, :user_group, id: 2)
      end

      it 'should separate different abilities' do
        expect(subject).to receive(:can).with(:index, :user, { :id => 1 })
        expect(subject).to receive(:can).with(:index, :user_group, { :id => 2 })
        subject.apply
      end
    end

    context 'ability with all permission' do
      before do
        subject.can_do(:index, :user)
        subject.can_do(:index, :user, business_id: 1)
      end

      it 'do not merge ability' do
        expect(subject).to receive(:can).with(:index, :user, {})
        expect(subject).to receive(:can).with(:index, :user, { :business_id => 1 })
        subject.apply
      end
    end

    context 'ability with with several conditions' do
      context 'conditions are equal' do
        before do
          subject.can_do(:index, :user, id: 1, business_id: 2)
          subject.can_do(:show, :user, id: 1, business_id: 2)
        end

        it 'merge abilities' do
          expect(subject).to receive(:can).with([:index, :show], :user, { :id => 1, :business_id => 2 })
          subject.apply
        end
      end

      context 'conditions are not equal' do
        before do
          subject.can_do(:index, :user, id: 1, business_id: 2)
          subject.can_do(:index, :user, id: 1, business_id: 3)
        end

        it 'do not merge abilities' do
          expect(subject).to receive(:can).with(:index, :user, { :id => 1, :business_id => 2 })
          expect(subject).to receive(:can).with(:index, :user, { :id => 1, :business_id => 3 })

          subject.apply
        end
      end
    end

    context 'equal single condition' do
      before do
        subject.can_do(:index, :user, id: 1)
        subject.can_do(:index, :user, id: 1)
      end

      it 'convert array to item for single condition value' do
        expect(subject).to receive(:can).with([:index], :user, { :id => 1 })
        subject.apply
      end
    end
  end
end
