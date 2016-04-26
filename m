From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: Re: [PATCH v2 17/18] xprtrdma: Remove ro_unmap() from all
 registration modes
Date: Tue, 26 Apr 2016 23:50:08 +0300
Message-ID: <571FD480.80100@grimberg.me>
References: <20160425185956.3566.64142.stgit@manet.1015granger.net>
 <20160425192307.3566.96703.stgit@manet.1015granger.net>
 <571FCF8E.1060304@grimberg.me>
 <2AB2B747-1D14-4885-9CEA-23104AC2A379@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <2AB2B747-1D14-4885-9CEA-23104AC2A379-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


>> Now we have ro_unmap_safe() which sorta implies that there
>> is a non-safe unmap? Why not just keep it ro_umap?
>
> Er, I would find that confusing too.
>
> How about name it ro_unmap_slow(), but it's for asynchronous
> cases too.

Heh, if a future nfs-rdma developer sees ro_unmap_slow() I assume his
first action is to grep ro_unmap_fast...

Anyway, it's not critical, your call..
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
