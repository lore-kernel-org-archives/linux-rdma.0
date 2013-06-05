From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: Re: [PATCH libmlx4 v6 1/2] libmlx4: Infra-structure changes to support
 verbs extensions
Date: Wed, 05 Jun 2013 09:54:33 -0500
Message-ID: <51AF5129.7020205@opengridcomputing.com>
References: <1364332591-22866-1-git-send-email-sean.hefty@intel.com> <51AE4288.4010505@opengridcomputing.com> <1828884A29C6694DAF28B7E6B8A823736FD2CF18@ORSMSX109.amr.corp.intel.com> <51AE47A3.5060802@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <51AE47A3.5060802-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org" <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tzahi Oved <tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 6/4/2013 3:01 PM, Steve Wise wrote:
> On 6/4/2013 2:46 PM, Hefty, Sean wrote:
>>>> +
>>>>    #ifdef HAVE_IBV_REGISTER_DRIVER
>>>>    static __attribute__((constructor)) void mlx4_register_driver(void)
>>>>    {
>>>> -    ibv_register_driver("mlx4", mlx4_driver_init);
>>>> +    verbs_register_driver("mlx4", mlx4_driver_init);
>>>> +
>>>>    }
>>>>    #else
>>> Shouldn't ibv_register_driver() need to be called in the lib 
>>> constructor
>>> function if HAVE_IBV_REGISTER_DRIVER is not defined?
>> ?  If HAVE_IBV_REGISTER_DRIVER is not defined, then we can't call 
>> ibv_register_driver...
>
> I thought HAVE_IBV_REGISTER_DRIVER was something new for deciding if 
> the lib should call verbs_register_driver().
>
>> We should just remove the HAVE_IBV_... check completely, since with 
>> this change, libmlx4 requires an updated version of libibverbs.
>
> Ah.  I was thinking it would use the old interface if it was compiled 
> against a libibverbs that didn't support the extensions.
>
>
>


So old provider libs will work with the new libibverbs but new provider 
libs will not work with the old libibverbs?   Is there no way around 
this?  That dependency can be painful.



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
