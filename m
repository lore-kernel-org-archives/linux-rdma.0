From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: Re: Removing NFS/RDMA client support for PHYSICAL memory registration
Date: Thu, 28 Apr 2016 13:59:33 +0300
Message-ID: <5721ED15.7030206@grimberg.me>
References: <20160425185956.3566.64142.stgit@manet.1015granger.net>
 <20160425192259.3566.58807.stgit@manet.1015granger.net>
 <571FCF03.4060406@grimberg.me>
 <1B0B3E47-05C0-4134-B486-0869628B453C@oracle.com>
 <C0D8DC78-C6AB-4926-AF27-5D51E16FD447@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <C0D8DC78-C6AB-4926-AF27-5D51E16FD447-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


>>> It's an awful lot of maintenance on what looks to be a esoteric (at
>>> best) code path.
>>
>> It's never chosen by falling back to that mode.
>>
>> physical has long been on the chopping block. Last time
>> I suggested removing it I got a complaint. But there's no
>> in-kernel device that requires this mode, so seems like
>> it should go sooner rather than later.
>
> I'm planning to add support for NFS/RDMA with Kerberos
> in v4.8. That seems like a very appropriate time to
> remove PHYSICAL, which is not secure.
>
> Is there any objection to removing PHYSICAL in v4.8?

Please do :)
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
