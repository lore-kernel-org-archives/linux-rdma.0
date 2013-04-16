From: Wendy Cheng <s.wendy.cheng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: IPOIB-CM MTU
Date: Tue, 16 Apr 2013 10:13:50 -0700
Message-ID: <CABgxfbFqz6k-v80DwV858pABA_LDw3dKKE2ijtcYFBuzZSvnig@mail.gmail.com>
References: <CABgxfbGeRAGMHUwWvHTs4kcoqNyEN3wBRG66n4sHrsKAMTce0g@mail.gmail.com>
	<CABgxfbGnDbKfHAiUuh=C1WPPa8OG2Sib_dcbvMvhu4zatC7BqQ@mail.gmail.com>
	<CAL1RGDV0V0gK-5UUBBOif_EiwHhGXMeRGsxuOvhoud76nBKpmw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAL1RGDV0V0gK-5UUBBOif_EiwHhGXMeRGsxuOvhoud76nBKpmw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Apr 16, 2013 at 9:02 AM, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org> wrote:
> On Mon, Apr 15, 2013 at 2:10 PM, Wendy Cheng <s.wendy.cheng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>> Before closing this thread ..... I see there is a clear warning in
>> IPOIB code that enabling connected mode will cause multicast packet to
>> drop. I assume this is due to message ordering requirement and the
>> multicast packet could fall behind the large packet fragment that ends
>> up causing multicast logic to time out. If my assumption is not
>> correct, please do kindly correct me.
>
> No, it's because multicasts can't be sent over the RC connections, so
> they need to be sent via UD.  And the datagram size is limited by the
> underlying IB MTU, which is going to be either 4K or 2K most likely.
> However if you enable CM and then set your IPoIB MTU to something like
> 64K, the IP stack will happily create multicast messages bigger than
> the datagram MTU, and the IPoIB driver really can't do anything with
> those except throw them away.
>

Great thanks (for the clarification) !

Now, assuming CM is only turned on with devices (e.g. MLX card) that
are capable of doing segmentation off-load, i.e. skb_is_gso() is true,
will this limitation (losing multicast packets) still exist ? I see
multicast and normal data packets are directed to different QPs,
aren't they ?

I'm trying to understand the ramifications of running IPOIB-CM in a
production environment, as it does perform (much) better.

Thanks,
Wendy
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
