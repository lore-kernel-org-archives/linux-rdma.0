From: Vasiliy Tolstov <v.tolstov-+9FY0jupvH6HXe+LvDLADg@public.gmane.org>
Subject: Re: How to do replication right with SRP or remote storage?
Date: Tue, 11 Jun 2013 13:48:36 +0400
Message-ID: <CACaajQs4q9q06xPU-_A19SjoZ629-=93-XrRnUQc-7dZs-Wdsw@mail.gmail.com>
References: <5054492E.1090403@acm.org> <loom.20121120T050107-224@post.gmane.org>
 <50AB84C1.5090105@acm.org> <loom.20130608T041932-498@post.gmane.org> <51B5C108.1030803@profitbricks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <51B5C108.1030803-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Cc: Bruce McKenzie <sales-uUyUjRhFbRmVZhT2dXthUg@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

2013/6/10 Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>:
> I can also recommend you Vasiliy Tolstov <v.tolstov-+9FY0jupvH6HXe+LvDLADg@public.gmane.org>. He also
> uses SRP with MD RAID-1. He could convince Neil to fix the MD data
> offet. OpenSource is all about the right allies,....


Thanks for recommendations... but --data-oofset already fixed.
Sometime ago Neil add this option when doing operations with raid. But
when i'm try it it does not works. After my message in LKML and MDADM
developers list Neil says, that it can be fixed.
As i see http://git.neil.brown.name/?p=mdadm.git;a=shortlog in May
this has been fixed.
May be we need to test this.

--
Vasiliy Tolstov,
e-mail: v.tolstov-+9FY0jupvH6HXe+LvDLADg@public.gmane.org
jabber: vase-+9FY0jupvH6HXe+LvDLADg@public.gmane.org
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
