From: Shirley Ma <shirley.ma-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: NFSoRDMA bi-weekly developers meeting minutes (4/2)
Date: Thu, 02 Apr 2015 10:53:35 -0700
Message-ID: <551D821F.5080006@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Charles EDWARD Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, "Anna.Schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org" <Anna.Schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>, "Devesh.Sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org" <Devesh.Sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "dominique.martinet-KCE40YydGKI@public.gmane.org" <dominique.martinet-KCE40YydGKI@public.gmane.org>, "jeffrey.c.becker-NSQ8wuThN14@public.gmane.org" <jeffrey.c.becker-NSQ8wuThN14@public.gmane.org>, "rsdance-rzwDkyJvnYokmLvzuZlaBw@public.gmane.org" <rsdance-rzwDkyJvnYokmLvzuZlaBw@public.gmane.org>, "skc-YOWKrPYUwWM@public.gmane.org" <skc-YOWKrPYUwWM@public.gmane.org>, "sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "SteveD-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <SteveD-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, "wendy.cheng-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <wendy.cheng-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "yanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <yanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Attendees:

Yan Burman (Mellanox)
Steve Dickson (Red Hat)
Chuck Lever (Oracle)
Shirley Ma (Oracle)
Sachin Prabhu (RedHat)
Devesh Sharma (Emulex)
Anna Schumaker (Net App)
Steve Wise (OpenGridComputing, Chelsio)

Moderator:
Shirley Ma (Oracle)

Today's meeting notes:
Sorry for the late start, it has changed from 7:30am PST time to 8:30am PST time but I didn't notice the change wasn't sent out. :( Thanks for your patient to join the call one hour later.

1. NFSoRDMA deployment:
NFSoRDMA has much better performance than NFSoIPoIB-CM in general. People are looking for both Linux NFSoRDMA client and Server support for deployment, however distros only support NFSoRDMA client at this moment. Developers have been fixing bugs on server side, more dedicated resources on NFSoRDMA server development are needed for stability and performance work. We will continue to improve NFSoRDMA performance and try to find more resources on server side.

2. NFSoRDMA performance
After experimenting performance with different approaches (multiple QPs, different completion vector per QP), we think we should focus on single QP scalability first. Right now small I/O single QP IOPS is around 100K, large I/O single QP NFS READ can reach 3.6GB/s (which almost reaches link speed in the fabric). To identify single QP scalability, here are list of things we can try:
-- Generic RPC dispatching: identify serialized operations to make them paralleled
-- scheduling mechanism: wait_on_bit latency, queue work latency
-- RDMA transport layer: hack poll_cq on both client and server to make pulling longer, like wait for RPC RTT time, wait for more WCs to process more completions to reduce interrupts/wait overheads to see any better results

3. We will cover iSCSI/iSER/SRP in the future discussions.

10/23/2014
@8:30am PT DST
@9:30am MT DST
@10:30am CT DST
@11:30am ET DST
@Bangalore @9:00pm
@Israel @6:30pm

Duration: 1 hour

Call-in number:
Israel: +972 37219638
Bangalore: +91 8039890080 (180030109800)
France  Colombes +33 1 5760 2222    +33 176728936
US: 8666824770,  408-7744073

Conference Code: 2308833
Passcode: 63767362 (it's NFSoRDMA, in case you couldn't remember)

Thanks everyone for joining the call and providing valuable inputs/work to the community to make NFSoRDMA better.

Shirley
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
