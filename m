From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: software iwarp stack update
Date: Sun, 19 Jun 2011 08:12:14 +0300
Message-ID: <4DFD852E.3050208@mellanox.com>
References: <BANLkTimEGgKEMZd3qppOofN-Vj-u-PH-xA@mail.gmail.com>	<OFB7458EEB.BFB8A4EE-ONC12578B1.004026D1-C12578B1.0041190E@ch.ibm.com>	<BANLkTi=2woNzF=GL3cT3NB_hye5JHfodMA@mail.gmail.com> <BANLkTi=L057TZug2=nrFZTYdNoHLMvmBRA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <BANLkTi=L057TZug2=nrFZTYdNoHLMvmBRA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>, Bernard Metzler <BMT-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>
Cc: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Bart Van Assche wrote:
> Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org> wrote:
>> It does seem we are missing an IB_MANDATORY_FUNC
>> entry for modify_port in ib_device_check_mandatory; or on
>> the flip side we are missing a check of modify_port and a
>> -ENOSYS return... I guess modify_port does not really make
>> sense for iWARP so probably the second option is better.
> 
> There seems to be disagreement about whether to return 0, -ENOSYS or
> -EOPNOTSUPP for not supported functionality. Does the patch below make sense ?
> Note: I don't have all the hardware necessary to test the patch below.

Bernard, the netdev guys have enough on their plate... what's the reason 
we want this thread the be cross posted to both linux-rdma and netdev?

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
