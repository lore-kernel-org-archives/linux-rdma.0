From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [Q] I tried to mount nfs_server:/mnt volume, but It mounted another volume.
Date: Sun, 21 Nov 2010 09:10:00 -0800
Message-ID: <adazkt2hac7.fsf@cisco.com>
References: <AANLkTi=vpRm3MEiQZ39bw5XwfjL6CVbGEkAKWz-ynEp_@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTi=vpRm3MEiQZ39bw5XwfjL6CVbGEkAKWz-ynEp_-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
	(Hiroyuki Sato's message of "Sun, 21 Nov 2010 21:23:31 +0900")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hiroyuki Sato <hiroysato-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Yes, as Boaz said, having two exports with fsid=0 is the problem:

 >   # cat /etc/exports
 >   /nfstest   192.168.100.0/255.255.255.0(fsid=0,rw,async,insecure,no_root_squash)
 >   /mnt       192.168.100.0/255.255.255.0(fsid=0,rw,async,insecure,no_root_squash)

you could have seen this in the server log from this:

 >   Nov 21 20:47:37 dell1435 mountd[3575]: /nfstest and /mnt have same
 > filehandle for 192.168.100.0/255.255.255.0, using first

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
