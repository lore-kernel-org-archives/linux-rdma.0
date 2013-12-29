From: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH V9 libmlx4 1/2] Infra-structure changes to support verbs
 extensions
Date: Sun, 29 Dec 2013 18:46:22 +0200
Message-ID: <52C051DE.6080904@dev.mellanox.co.il>
References: <1375369555-11416-1-git-send-email-yishaih@mellanox.com> <1375369555-11416-2-git-send-email-yishaih@mellanox.com> <CAL1RGDXmbkeyxwsxduJEq9K6x_S4-q-txiR2pziS3tX-BKV76g@mail.gmail.com> <20131223182120.GE25089@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20131223182120.GE25089-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Cc: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tzahi Oved <tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 12/23/2013 8:21 PM, Jason Gunthorpe wrote:
> On Mon, Dec 23, 2013 at 09:35:46AM -0800, Roland Dreier wrote:
>> On Thu, Aug 1, 2013 at 8:05 AM, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
>>> #ifdef HAVE_IBV_REGISTER_DRIVER
>>>   static __attribute__((constructor)) void mlx4_register_driver(void)
>>>   {
>>> -       ibv_register_driver("mlx4", mlx4_driver_init);
>>> +       verbs_register_driver("mlx4", mlx4_driver_init);
>>>   }
>>>   #else
>> So just to be clear, after this change libmlx4 will no longer build or
>> work with libibverbs <= 1.1.7 (1.1.8 is unreleased but is the one with
>> the verbs extension changes)?
> Right, but is it more than just that hunk..
>   
>> If so does it make sense to have this autoconf stuff
>> (HAVE_IBV_REGISTER_DRIVER) for compatibility with libibverbs 1.0.x?
> None, it should be dropped, and the kind thing would be to have
> configure bail if verbs_register isn't found.
>
>> How hard would it be to add an autoconf check for
>> verbs_register_driver() and keep compatibility with libibverbs 1.1.7?
> Not sure that is useful. I can't think of any reason someone would
> actually want to do that, and doing the autoconf test sort of implies
> that someone actually tested it, it works, and it is a sane thing to
> do..
>
> Jason
     Right, the idea was that libibverbs with verbs extension will 
support both types of providers, w/w.o verbs extension but provider with 
verbs extension
     (e.g. libmlx4) will require the extended libibverbs.
     Re libibverbs, I have reviewed your GIT with the extensions - seems 
to be fine.

     Roland - please move forward and take libmlx4 as well, there are 
some distros who are waiting for.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
