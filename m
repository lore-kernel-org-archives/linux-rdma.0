From: Bang Nguyen <bang.nguyen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: APM support for IPoIB
Date: Tue, 02 Oct 2012 17:14:29 -0700
Message-ID: <506B8365.9010507@oracle.com>
References: <506A17EA.8080400@oracle.com> <20121001235303.GH22342@obsidianresearch.com> <506A2F01.8000605@oracle.com> <CAL1RGDWmywbGg0vVb_MqRCHbdgMCZTGN5Y-dX6NkpWRB6P23ug@mail.gmail.com> <CD250C48050CFB4D95E78C95F2FDDD6E87470513@MTLDAG01.mtl.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CD250C48050CFB4D95E78C95F2FDDD6E87470513-fViJhHBwANKuSA5JZHE7gA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tziporet Koren <tziporet-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Richard Frank <richard.frank-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

  On 10/2/2012 1:12 AM, Tziporet Koren wrote:
>> Perhaps working on getting that merged upstream would be a better first step.
> We have it on our plans to submit RDMA-CM APM to upstream.
> Since we are in holidays season here it will take us some time to come back with plan.
>
> In any case as Bang wrote this is not related to IPoIB-CM, that requires a different implementation, and any one is welcome to contribute here :-)
>
> Tziporet
>
Just a crazy thought but IPoIB could use RDMA-CM for all of its 
connection management stuff..this way it can leverage the APM support in 
RDMA-CM..

comments?...

Thanks, --Bang.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
