From: "Jeff Squyres (jsquyres)" <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] libibverbs init.c: remove stderr warnings if no
 userspace driver found
Date: Tue, 12 May 2015 14:10:35 +0000
Message-ID: <7E1C0E26-E71D-4939-BCBB-A5FC666DE381@cisco.com>
References: <1431109314-31662-1-git-send-email-jsquyres@cisco.com>
 <1431180267.3617.5.camel@dworkin>
 <91CD4206-FE67-45DF-BFFD-3AFBC4DE30E3@cisco.com>
 <1431379962.4969.7.camel@dworkin>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1431379962.4969.7.camel@dworkin>
Content-Language: en-US
Content-ID: <EFC379C00BEBA24EA01EAAC6AF5DE86E-WwaMAgPkaIIluPl5bxqUMw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On May 11, 2015, at 2:32 PM, Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org> wrote:
> 
> (I have to find some information about this libfabric which is already
> released as 1.0.0 version).

See http://ofiwg.github.io/libfabric/ (and the corresponding code https://github.com/ofiwg/libfabric).

>> That is: it's not a warning or an error if libibverbs cannot find a
>> userspace driver for kernel devices.  Indeed, returning a num_devices
>> of 0 is sufficient -- the middleware shouldn't be unconditionally
>> printing out stderr message; let the upper layer application do that
>> (if it wants to).
> 
> This paragraph should definitively be part of your commit message.

Ok.

>> FWIW, Sean just removed a similar set of stderr warnings from librdmacm:
>> 
>>   http://git.openfabrics.org/?p=~shefty/librdmacm.git;a=commitdiff;h=2b2aad809afc56fa3157f5cf99036f92b9c90f16
> 
> I don't think this a good thing to remove all the error messages
> unconditionally. It could have been made a build option + an environment
> variable option to help mere mortals to debug their setups.

Ok.  v3 coming shortly.

-- 
Jeff Squyres
jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org
For corporate legal information go to: http://www.cisco.com/web/about/doing_business/legal/cri/

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
