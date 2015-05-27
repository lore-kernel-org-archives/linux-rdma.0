From: Jesus Camacho Villanueva <jesus.camacho-CZJJ9ELfIp3ZJqsBc5GL+g@public.gmane.org>
Subject: Re: out of order packets when querying all ports in a switch through OpenSM
Date: Wed, 27 May 2015 17:31:12 +0200
Message-ID: <CAGNdY=4iODDSiYdQ7UQdYBQUi7hs8x8-1BqTQk8ZLmpfeovPeQ@mail.gmail.com>
References: <CAGNdY=4ox_P_XB+gaFoQvec=j9qp4RKOxrM9vsL_FAXAE3oYow@mail.gmail.com>
	<5565CCB8.8060600@dev.mellanox.co.il>
	<CAGNdY=6RQS9F4Or+fEudpVj0iRKJ_95LiG0O2+n=GG3WqzKP6w@mail.gmail.com>
	<5565D518.30602@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5565D518.30602-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

The switches are unmanaged.
Is it possible to ensure in-order packets with managed switches?

Jesus

On Wed, May 27, 2015 at 4:30 PM, Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> wrote:
> On 5/27/2015 10:16 AM, Jesus Camacho Villanueva wrote:
>> Hi Hal,
>>
>> Thanks for your quick response :)
>>
>> What you say here makes sense. I have seen this behaviour in one of
>> the switches, but I don't discard that this problem can arise in other
>> switches.
>
> Note that for MADs, transaction ID is "looser" than traditional
> transaction ID semantics in that "the combination of TID, SGID, and
> MgmtClass is different from that of any currently executing operation"
> and does not imply ordering. If there is ordering required, it is the
> responsibility of the manager to enforce that.
>
>> The switch is: Infiniscale-IV Mellanox Technologies 4xQDR
>
> Is it a managed or unmanaged switch ?
>
> -- Hal
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
