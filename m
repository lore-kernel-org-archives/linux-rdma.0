From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: Re: Fwd: circular lockdep problem
Date: Tue, 24 Jul 2012 14:44:25 -0500
Message-ID: <500EFB19.2090809@opengridcomputing.com>
References: <500ECFCD.1040403@opengridcomputing.com> <CAL1RGDUaUN-X2Ju=SdHf-b8Kjh5K+wZ36aMQNZkn5xsG8yLrUQ@mail.gmail.com> <CAL1RGDV9gGYuX6WBcjWeWUAeFo3A-jZsAX86XPwbf8cttDO4Tg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAL1RGDV9gGYuX6WBcjWeWUAeFo3A-jZsAX86XPwbf8cttDO4Tg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 07/24/2012 12:06 PM, Roland Dreier wrote:
> [resending because I forgot to reply-all]
>
> On Tue, Jul 24, 2012 at 9:39 AM, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org> wrote:
>> Can anyone help me understand how I can resolve this? Its saying there is
>> some circular dependency problem with the cxgb4 uld_mutex, the networking
>> rtnl_mutex, and ib_core's device_mutex. I can't decipher the stuff below
>> though. It only seems to happen when there is a cxgb4 and ipoib device
>> present.
> Do you have a real IB HCA installed too?

Yes.

> I suspect this is a lockdep false positive where it is mixing together
> lock ordering from the IB - IPoIB adapter and the cxgb4 netdev,
> and seeing a deadlock that can't really happen.
>
> I'll take a look, although I don't have a cxgb4 device so I can't test
> directly.  Would you be able to test a patch if I come up with one?

Sure!

Steve.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
