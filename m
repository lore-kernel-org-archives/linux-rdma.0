From: Tziporet Koren <tziporet-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Subject: Re: FW: [PATCHv10 02/12] ib_core: IBoE CMA device binding
Date: Sun, 26 Sep 2010 18:46:12 +0200
Message-ID: <4C9F78D4.10903@mellanox.co.il>
References: <F57121538EA0C94F86018DDD40ADA1D10223D9F3@mtiexch01.mti.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <F57121538EA0C94F86018DDD40ADA1D10223D9F3-SDnKeQl2TTymvrjiD8yIlgC/G2K4zDHf@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: Linux RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Sep 02, 2010 at 01:10:17PM -0700, Roland Dreier wrote:
>> Please just resend this, thanks.
>>      
> Here's the new code. I added a function that tries to find a match for
> a given port, istead of ib_find_cached_gid() which searches all the
> ports.
> I tested this on a machine with two cards with different
> configurations and it works fine.
>
>
>    

Roland,

Following Eli's update below, we have not received any further comments on this matter. Please confirm that this is in line with what you had requested.

Also, having not heard any other concerns with the rest of the iboe v10 patchset, we assume it is in good shape for upstream integration in the upcoming 2.6.37. If there is anything further that you would like us to modify please let us know and we will do it immediately.

Thanks,
Tziporet


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
