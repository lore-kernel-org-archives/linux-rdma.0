From: Shlomo Pongratz <shlomop-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: Different signatures to ibv_open_xrcd - branch issue?
Date: Tue, 26 Mar 2013 23:04:03 +0200
Message-ID: <51520D43.2060006@mellanox.com>
References: <51502C30.2000806@mellanox.com> <1828884A29C6694DAF28B7E6B8A823736F367AB8@ORSMSX101.amr.corp.intel.com> <515173F2.4030506@mellanox.com> <1828884A29C6694DAF28B7E6B8A823736F36825D@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A823736F36825D-P5GAC/sN6hmkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 3/26/2013 5:56 PM, Hefty, Sean wrote:
>> I understand that currently I can't do RDMA using XRC, is that the case?
>> How complicated are the required modifications needed to make librdmacm
>> complies to the libibverbs changes?
> The changes needed for the librdmacm to support XRC aren't huge.  The complication is getting XRC merged with libibverbs.
I think I missed something here, can I use your branch xrc2 of 
libibverbs for testing purpose, or there are still things to merge there?
And for librdmacm, I'm looking forward to try it with a real application 
the moment you'll have a branch witch is compatible with libibverbs.

S.P.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
