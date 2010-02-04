From: Or Gerlitz <ogerlitz-hKgKHo2Ms0FWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 0/8] ib/iser: major face lift of the data path code
Date: Thu, 04 Feb 2010 16:21:09 +0200
Message-ID: <4B6AD7D5.7030204@Voltaire.com>
References: <Pine.LNX.4.64.1002031721280.11944@zuben.voltaire.com> <e2e108261002030811r5c740d6fr4cc055702a88aa50@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <e2e108261002030811r5c740d6fr4cc055702a88aa50-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Mike Christie <michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org>, Yaron Haviv <yaronh-smomgflXvOZWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Bart Van Assche wrote:
> Sounds really interesting. Do you have numbers available about how
> much these patches improve throughput or decrease latency ?

Yes, generally speaking after the patches the initiator peaks to about 300-400K IOPS
with latency under such load being 20-30us and before the patches the initiator was
doing upto 200K IOPS with the latency under such load being 50-100us, see some data
I got today on mytest bed. Being focused on the initiator, I was using a "NULL device"
at the target side.

AFTER

 r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa st
11 11      0 6212936 260552 367356    0    0 308671     0 285596 492842  4 64  0 31  0
 7 13      0 6212936 260552 367356    0    0 309628    24 285138 496537  5 61  0 33  0
10 12      0 6212936 260552 367356    0    0 308222     0 277868 489261  4 65  0 30  0
 8 13      0 6212936 260552 367356    0    0 310724     0 282151 493868  4 67  0 29  0
12 11      0 6212936 260552 367356    0    0 308209     0 278753 489797  5 66  0 29  0

Linux 2.6.33-rc4 (cto-1) 	02/04/2010

avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           4.62    0.00   66.29   28.71    0.00    0.37

Device:         rrqm/s   wrqm/s   r/s   w/s   rsec/s   wsec/s avgrq-sz avgqu-sz   await  svctm  %util
sdd               0.00     0.00 88905.94  0.00 177811.88     0.00     2.00     2.82    0.03   0.01  98.61
sdf               0.00     0.00 64021.78  0.00 128045.54     0.00     2.00     2.55    0.04   0.02  96.24
sdh               0.00     0.00 88922.77  0.00 177845.54     0.00     2.00     2.85    0.03   0.01  99.01
sdj               0.00     0.00 64662.38  0.00 129324.75     0.00     2.00     2.69    0.04   0.02  97.82

BEFORE

 r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa st
 6 14      0 6211804 260684 368584    0    0 195551     0 195997 557463  3 56  4 37  0
 7 13      0 6211804 260684 368584    0    0 191347     0 192311 525823  3 58  3 36  0
 6 15      0 6211804 260692 368584    0    0 187135    16 190875 503739  3 58  3 35  0
 8 14      0 6211804 260692 368584    0    0 193745     0 193921 556821  3 55  4 38  0
 8 16      0 6211804 260692 368584    0    0 191233     0 191549 536499  3 58  4 35  0

Linux 2.6.33-rc4 (cto-1) 	02/04/2010

avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           2.24    0.00   58.16   35.87    0.00    3.74

Device:         rrqm/s   wrqm/s   r/s   w/s   rsec/s   wsec/s avgrq-sz avgqu-sz   await  svctm  %util
sdd               0.00     0.00 33964.00  0.00 67928.00     0.00     2.00     3.36    0.10   0.03 100.00
sdf               0.00     0.00 33456.00  0.00 66912.00     0.00     2.00     3.34    0.10   0.03  99.60
sdh               0.00     0.00 63176.00  0.00 126352.00     0.00     2.00     3.40    0.05   0.02 100.00
sdj               0.00     0.00 62973.00  0.00 125946.00     0.00     2.00     3.38    0.05   0.02 100.40

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
