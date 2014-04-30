From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: NFSoRDMA developers bi-weekly meeting announcement (4/30)
Date: Wed, 30 Apr 2014 15:47:57 -0400
Message-ID: <BBF761A6-2407-4457-92D5-8C2EC736BC9D@oracle.com>
References: <53614C03.80606@oracle.com> <CAJZOPZJioYdcbDGsk7278sZS7kD9W1dcGEGtYfsFk=Mm7DW3fQ@mail.gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 7.2 \(1874\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJZOPZJioYdcbDGsk7278sZS7kD9W1dcGEGtYfsFk=Mm7DW3fQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Shirley Ma <shirley.ma-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Jeff Becker <jeffrey.c.becker-NSQ8wuThN14@public.gmane.org>, "<yanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>" <yanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Cayton, Phil" <phil.cayton-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Coulter, Susan K" <skc-YOWKrPYUwWM@public.gmane.org>, Anna Schumaker <Anna.Schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>, "<Devesh.Sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>" <Devesh.Sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Allen Andrews <Allen.Andrews-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Trond Myklebust <trond.myklebust-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>, "<emossman-zcUZCMB5SQOVc3sceRu5cw@public.gmane.org>" <emossman-zcUZCMB5SQOVc3sceRu5cw@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Or-

On Apr 30, 2014, at 3:39 PM, Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> On Wed, Apr 30, 2014 at 10:16 PM, Shirley Ma <shirley.ma-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> wrote:
> [...]
>> 3. Upstream NFSoRDMA status:
> 
> 
> So does it currently works...? I understand that Yan tried it out
> today, and @ least one side just crashed.
> 
> Chuck, I assume there is a configuration which basically works for you
> and allow you to develop the upstream patches, you send, right?  can
> you send us your .config and exact NFS/rNFS options you use and works
> basically OK?

If I understood Yan, he is trying to use NFS/RDMA in guests (kvm?).  We
are pretty sure that is not working at the moment, but that is a priority
to get fixed. Shirley has a lab set up and has been looking into it.

So, first step would be to set up v3.15-rc3 on bare metal.

I think the critical stability patches for both client and server are
already upstream, unless you are exporting tmpfs.

The patches I just posted fix some other issues, feel free to apply them.
But the basics should be working now in v3.15-rc3.

--
Chuck Lever
chuck[dot]lever[at]oracle[dot]com



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
