From: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-core 5/6] redhat/spec: clean up rsocket packaging
Date: Thu, 22 Dec 2016 13:23:09 -0500
Message-ID: <5f0f6060-deb4-da27-c6a0-12d1ede4ca2b@redhat.com>
References: <20161221220840.36268-1-jarod@redhat.com>
 <20161221220840.36268-6-jarod@redhat.com>
 <140dc3aa-6088-c4cf-5a8a-1a0426f55cd3@redhat.com>
 <20161222173302.GA29518@obsidianresearch.com>
 <74c5651b-4125-0a7a-3184-d510814cdc0d@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <74c5651b-4125-0a7a-3184-d510814cdc0d-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 2016-12-22 1:15 PM, Doug Ledford wrote:
> On 12/22/2016 12:33 PM, Jason Gunthorpe wrote:
>> On Thu, Dec 22, 2016 at 02:17:52AM -0500, Jarod Wilson wrote:
>>>> %files -n librdmacm
>>>> %{_libdir}/librdmacm*.so.*
>>>> -%{_libdir}/rsocket/*.so.*
>>>> +%dir %{_libdir}/rsocket
>>>> +%{_libdir}/rsocket/*.so
>>>
>>> Minor error here, should be rsocket/*.so* to pick up the symlinks too, at
>>> least until they get neutered.
>
> I hand fixed this when taking the original series BTW...

Okay, this fixup was in my follow-up patch as well. Guessing what to 
patch against a little, since it's not pushed yet. ;)

>> FWIW, it would also be appropriate to put the LDPRELOAD library into
>> librdmacm-utils..
>
> I'm pretty sure the Fedora standards would want it in librsocket and not
> in a -utils package.  The -utils package should be executables and not
> libraries.

Yeah, I think it's probably best where it is now.

Do you want a re-respin of the follow-up patch to drop the chmod bit and 
duplicitous librspreload fixup, or can you just smash it all together?

-- 
Jarod Wilson
jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
