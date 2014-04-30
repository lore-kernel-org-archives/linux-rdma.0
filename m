From: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: NFSoRDMA developers bi-weekly meeting announcement (4/30)
Date: Wed, 30 Apr 2014 23:00:31 +0300
Message-ID: <CAJZOPZJgp-QdxR+PmwACWOSc4h_167J0iBjfmMrPX8sek600WA@mail.gmail.com>
References: <53614C03.80606@oracle.com>
	<CAJZOPZJioYdcbDGsk7278sZS7kD9W1dcGEGtYfsFk=Mm7DW3fQ@mail.gmail.com>
	<BBF761A6-2407-4457-92D5-8C2EC736BC9D@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <BBF761A6-2407-4457-92D5-8C2EC736BC9D-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Shirley Ma <shirley.ma-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Jeff Becker <jeffrey.c.becker-NSQ8wuThN14@public.gmane.org>, "<yanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>" <yanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Cayton, Phil" <phil.cayton-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Coulter, Susan K" <skc-YOWKrPYUwWM@public.gmane.org>, Anna Schumaker <Anna.Schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>, "<Devesh.Sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>" <Devesh.Sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Allen Andrews <Allen.Andrews-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Trond Myklebust <trond.myklebust-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>, "<emossman-zcUZCMB5SQOVc3sceRu5cw@public.gmane.org>" <emossman-zcUZCMB5SQOVc3sceRu5cw@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Apr 30, 2014 at 10:47 PM, Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

> If I understood Yan, he is trying to use NFS/RDMA in guests (kvm?).  We
> are pretty sure that is not working at the moment,

can you provide a short 1-2 liner why/what is broken there? the only
thing which I can think of to be not-supported over mlx4 VFs is the
proprietary FMRs, but AFAIK, the nfs-rdma code doesn't even have a
mode which uses them, right?

> but that is a priority
> to get fixed. Shirley has a lab set up and has been looking into it.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
