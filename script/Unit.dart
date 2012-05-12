#library("Unit");

/**
  * Unit for animation
  */
class Unit {
    const Unit(int id) : _id = id;

    String toString() {
        switch (_id)
        {
        case PixelID:
            return "px";
        case MillisecID:
            return "ms";
        default:
            return "px";
        }
    }

    final int _id;

    static final int PixelID = 0;
    static final int MillisecID = 100;
    static final Pixel = const Unit(PixelID);
    static final Millisecond = const Unit(MillisecID);
}

