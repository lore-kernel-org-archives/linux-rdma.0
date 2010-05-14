From: Bob Ciotti <Bob.Ciotti-NSQ8wuThN14@public.gmane.org>
Subject: vl15 drops
Date: Fri, 14 May 2010 12:55:04 -0700
Message-ID: <20100514195504.GA16471@nas.nasa.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

We are chasing down some issues related to fabric discovery and SM failover
and occasionally we see a significant number of vl15 drops and are not sure
if this is a problem or not. Anyone have a reference on what controls are 
available to reduce the number of drops? We would like to keep maxsmps set to at
least 16 or even raise it. Spec says at least one vl15 buffer, but are there
controls for buffer allocation on the switches wrt vl15, or other vl15
specific controls (in SM or switches or?) that might reduce drops?

Its a collection of InfiniscaleIII and IV.

Here is a small subset of the VL15 counters on a few on the switches.
Each line corresponds to a 24 port infiniscaleIII switch. All the d1 
thru d11 (hypercube dimensions) connections are to other switches (not HCA).

r53i3/sw0/port 24 is where the SM is connected showing 9678 drops...


    -- cb1 ib0 sw0     .    .      .                    .   d1   d2   d3  d4  d5   d6  d7  d8 d9 d10   d11  d12   io 
    == cb1 ib0 sw0     .    .      .         SWPORT          9   13   14  15  16   17  18  19 20  21    22   23   24 
 r49i0 cb1 ib0 sw0 SwLid 7842 port-1         VL15Dropped:    .    .    1   3   8   13  11   .  .   .     .    .    . 
 r49i1 cb1 ib0 sw0 SwLid 8349 port-1         VL15Dropped:    .    .   17   8  20   16   2   2  .   .     .    .    . 
 r49i2 cb1 ib0 sw0 SwLid 8554 port-1         VL15Dropped:    .    4    .  12  23    2   2   .  2   .     .    .    . 
 r49i3 cb1 ib0 sw0 SwLid 7330 port-1         VL15Dropped:    3    1    1  25  71   57   7   8  1   .     .    .    . 
 r50i0 cb1 ib0 sw0 SwLid 8682 port-1         VL15Dropped:    .    2   61   3   6    7   .   5  .   .     .    .    . 
 r50i1 cb1 ib0 sw0 SwLid 8132 port-1         VL15Dropped:    .    3   58  33  20   44   1   9  4   .     .    .    . 
 r50i2 cb1 ib0 sw0 SwLid 6435 port-1         VL15Dropped:    4  122   14   8  13   36   2   .  .   .     .    .    . 
 r50i3 cb1 ib0 sw0 SwLid 8027 port-1         VL15Dropped:   22  171  167  49 113   57   .   2  .   .     .    .    . 
 r51i0 cb1 ib0 sw0 SwLid 7756 port-1         VL15Dropped:    .    .    3  24  16   11   .   2  .   .     .    .    . 
 r51i1 cb1 ib0 sw0 SwLid 6678 port-1         VL15Dropped:    .    5    8  28   7   27   2   .  4   .     .    .    . 
 r51i2 cb1 ib0 sw0 SwLid 7933 port-1         VL15Dropped:    1   34   29   3   7    5   2   .  .   .     .    .    . 
 r51i3 cb1 ib0 sw0 SwLid 7426 port-1         VL15Dropped:   14   31  145 683  18    5   2   .  1   .     .    .    . 
 r52i0 cb1 ib0 sw0 SwLid 6990 port-1         VL15Dropped:    1   26   65  23 132   49   1   1  1   .     .    .    . 
 r52i1 cb1 ib0 sw0 SwLid 7465 port-1         VL15Dropped:   33   66  388  48  18    4   4   .  2   .     .    .    . 
 r52i2 cb1 ib0 sw0 SwLid 6914 port-1         VL15Dropped:   17  320   39  14  15   12   4   5  4   .     .    .    . 
 r52i3 cb1 ib0 sw0 SwLid 7895 port-1         VL15Dropped: 1770  614 1449 189 299  197  35 124 56   .    55    . 9678 
 r53i0 cb1 ib0 sw0 SwLid 8171 port-1         VL15Dropped:    .    .    .   .   1    5   .   .  .   .     .    .    . 
 r53i1 cb1 ib0 sw0 SwLid 8471 port-1         VL15Dropped:    .    .    1   .   .   15   3   1  5   .     .    .    . 
 r53i2 cb1 ib0 sw0 SwLid 6485 port-1         VL15Dropped:    .    .    .   .   8   17   2   .  2   .     .    .    . 
 r53i3 cb1 ib0 sw0 SwLid 5949 port-1         VL15Dropped:    .    .    1   3   3    1   8   .  .   .     .    .    . 
 r54i0 cb1 ib0 sw0 SwLid 7809 port-1         VL15Dropped:    .    .    .   .   2    .   2   .  .   .     .    .    . 
 r54i1 cb1 ib0 sw0 SwLid 7890 port-1         VL15Dropped:    .    .    .   4  16    1   .   .  2   .     .    .    . 
 r54i2 cb1 ib0 sw0 SwLid 6913 port-1         VL15Dropped:    .    1    .   1  21    4   4   .  3   .     .    .    . 
 r54i3 cb1 ib0 sw0 SwLid 7283 port-1         VL15Dropped:    1   11    1   7  34    4  18   .  2   .     .    .    . 
 r55i0 cb1 ib0 sw0 SwLid 8350 port-1         VL15Dropped:    .    .    .   2   .    8   7   .  .   .     .    .    . 
 r55i1 cb1 ib0 sw0 SwLid 7516 port-1         VL15Dropped:    .    .    3  24  13    3   4   .  1   .     .    .    . 
 r55i2 cb1 ib0 sw0 SwLid 8518 port-1         VL15Dropped:    .    6    .  16   .    1   4   1  .   .     .    .    . 
 r55i3 cb1 ib0 sw0 SwLid 7666 port-1         VL15Dropped:    .    .    9  12   4    4  20   1  .   .     .    .    . 
 r56i0 cb1 ib0 sw0 SwLid 8219 port-1         VL15Dropped:    .    3   29  12   .    6   .   .  1   .     .    .    . 
 r56i1 cb1 ib0 sw0 SwLid 5912 port-1         VL15Dropped:    .    3   11  13   4   13   .   .  2   .     .    .    . 
 r56i2 cb1 ib0 sw0 SwLid 7329 port-1         VL15Dropped:    1  105   39  27   1    1   1   .  .   .     .    .    . 
 r56i3 cb1 ib0 sw0 SwLid 7424 port-1         VL15Dropped:   14    6   11  77  10   46   4   2  .   .     .    .    . 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
