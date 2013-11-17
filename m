From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH for-next 0/6] Add flow steering support for IPoIB
Date: Sun, 17 Nov 2013 08:53:46 +0200
Message-ID: <528867FA.60604@mellanox.com>
References: <1383830717-17312-1-git-send-email-ogerlitz@mellanox.com> <CAJZOPZK=mRXakostsuFt3XzP3ZF5FW+4YurTSRz1JbPBgzurCg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJZOPZK=mRXakostsuFt3XzP3ZF5FW+4YurTSRz1JbPBgzurCg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 16/11/2013 21:35, Or Gerlitz wrote:
> On Thu, Nov 7,Or Gerlitz<ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>  wrote:
>
>> >This series adds on the flow-steering patches that were merged in 3.12
>> >Now flow steering rules can be set such that they steer UD
>> >traffic targeted to IPoIB netdevice into applications IB UD QP.
>> >For that end, IPoIB provides hint to the low-level device through
>> >a QP creation flag that this QP may be subject to flow-steering.
>> >FWIW, this patch set has nothing to do with the uverbs extensions series.
> Any comment?! is this going in for 3.13?
>
> Note that without this series which enables flow-steering also on IB
> ports, folks that have VPI environments, e.g dual ported HCA with one
> port playing Ethernet and the 2nd port IB, can't enjoy flow-steering
> since we have only one dev cap bit and the flow-steering patches that
> went into 3.12 only implemented the feature for raw qps, so the driver
> (mlx4) could enable the device capability when both ports are IB.
that was late nightish comment with a typos, to make it clear: the flow 
steering patches
that were merge in 3.12 lack the support for IB UD QPs and hence the low 
level driver could
enable the verbs level dev cap bit for flow steering only when both 
ports are Ethernet.

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
