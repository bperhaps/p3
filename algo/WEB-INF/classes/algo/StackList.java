package algo;
import java.util.*;

public class StackList {

	public class StackList {
		private ArrayList stack;

		/**
		 * 스택 인스턴스를 생성하는 컨스트럭터(Constructor)
		 */
		public StackList() {
			stack = new ArrayList();
		}

		/**
		 * 스택을 최소 사이즈 s 로 생성한다
		 * 
		 * @param s 구현할 스택의 최소 사이즈
		 */
		public StackList(int s) {
			stack = new ArrayList();
			stack.ensureCapacity(s);
		}

		/**
		 * 스택을 비운다
		 */
		public void clear() {
			stack.clear();
		}

		/**
		 * 스택이 Empty 상태인지 확인한다
		 * 
		 * @return 스택이 Empty 상태이면 true값을, 아니면 false 값을 반환한다.
		 */
		public boolean isEmpty() {
			return stack.isEmpty();// 또는 "stack.size() == 0"를 이용할수도 있다
		}

		/**
		 * 새로운 요소를 삽입한다
		 * 
		 * @param e 삽입될 새로운 요소
		 */
		public void push(Object e) {
			stack.add(e);// ArrayList의 가장 마지막 index 에 새로운 요소를 삽입한다
		}

		/**
		 * 스택에서 가장 최 상위에 위치한 데이터를 추출한 후 제거한다.
		 * 
		 * @return 스택에서 가장 최 상위에 위치한 데이터
		 */
		public Object pop() {
			if (isEmpty()) {// 우선 스택이 empty 인걸 확인한 하고
				throw new EmptyStackException();
				// 그렇다면 Exception 을 던진다
			} else {
				return stack.remove(stack.size() - 1);
				// ArrayList.remove 메소드는 어레이에서 주어진 인덱스의 데이터를 제거후, 리턴한다 
			}
		}

		/**
		 * 스택에서 가장 최상위에 위치한 데이터를 리턴한다, pop 메소드와는 달리 제거하지 않는다.
		 * 
		 * @return 스택에서 가장 최 상위에 위치한 데이터
		 */
		public Object peek() {
			if (isEmpty()) {
				throw new EmptyStackException();

			} else {
				return stack.get(stack.size() - 1);
				// ArrayList.get 메소드는 주어진 인덱스에 저장된 값을 반환한다.
			}
		}
	}
}
