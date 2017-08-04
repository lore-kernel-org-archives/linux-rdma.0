From: Nicolas Morey-Chaisemartin <NMoreyChaisemartin-l3A5Bk7waGM@public.gmane.org>
Subject: Re: rdma-core build environment enabling out-of-core providers
Date: Fri, 4 Aug 2017 13:52:50 +0200
Message-ID: <188beb70-9776-33fc-6f72-cc00e968db73@suse.de>
References: <007601d30b96$f2408170$d6c18450$@opengridcomputing.com>
 <20170802160900.GB21208@obsidianresearch.com>
 <019001d30bc3$cc6648e0$6532daa0$@opengridcomputing.com>
 <44b511c6-45fa-d5aa-4d4c-e47d2edcf604@suse.de>
 <008401d30c5f$3c9e2560$b5da7020$@opengridcomputing.com>
 <20170803144733.GA13127@obsidianresearch.com>
 <890f961c-7aa8-1a73-e98d-f7ce9da333d7@suse.de>
 <20170803170713.GD13127@obsidianresearch.com>
 <7cc0ba31-7a05-4db1-5807-4d971fc3d773@suse.de>
 <011f01d30d15$1fa92750$5efb75f0$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <011f01d30d15$1fa92750$5efb75f0$@opengridcomputing.com>
Content-Language: fr-xx-classique+reforme1990
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, 'Jason Gunthorpe' <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: 'Leon Romanovsky' <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, 'Doug Ledford' <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org



Le 04/08/2017 à 13:30, Steve Wise a écrit :
>> Le 03/08/2017 à 19:07, Jason Gunthorpe a écrit :
>>> On Thu, Aug 03, 2017 at 05:01:16PM +0200, Nicolas Morey-Chaisemartin
>> wrote:
>>>> I haven't looked into the build system but isn't this something the
>>>> devel rpm could provide ?
>>> Conceptually, perhaps, but someone has to figure out how to split out
>>> the necessary cmake bits into something reusable, it is no longer
>>> entirely trivial :)
>> Yes, this is going to take some time.
>>
>>> Also don't forget that the internal API inside the header files
>>> changes, a provider that has been modified for rdma core 15 will not
>>> compile on rdma core 13, just like the kernel..
>> I guess there are enough VERSION defines in rdma-core to make the
>> provider portable.
>> But yes, supporting multiple versions is a lot more work.
>>
> I'm not sure the rdma-core needs to worry about this, other than to provide a compile-time way to detect the version.  IE I don't think rdma-core v15 should bother supporting out-of-tree providers that don't support the v15 provider<->libibverbs API.  It would be up to the out-of-tree providers to support both v13 and v15, for example. 
It's just a matter of exporting the PACKAGE_VERSION from the CMakeLists to one the future header to install.
It's not required, but I guess it'll make the job of out-of-tree providers easier if they can just adapt to the proper API depending on this.

>>> I just wonder if it is worth the all the proposed work, I expect out
>>> of tree providers to be very rare and temporary things.
>> The lazy (smart?) thing to do here is to wait for an out-of-tree provider to
>> need it (Steve ?) and give them some support to do it.
>> If they can't be bothered, it's probably not worth it. If they want it, they'll
>> do most of the work and the feature gets upstreamed.
>>
> Oh I'm already bothered.  😊  I will sign up for this.  If I fall in and sink, hopefully Jason will fish me out of the drink.  Cmake is new to me.
>
>>>> If this is done upstream once and for all, and not by every
>>>> out-of-tree provider, it is not fragile anymore.
>>> Someone would also have to contribute some kind of test infrastructure
>>> to keep it working for upstream.. If it doesn't run in cbuild I don't
>>> test it :P
>> It shouldn't be too hard to automatically extract one of the in-tree provider
>> and try to compile it as an out-of-tree.
>> And this way it's always up-to-date for testing.
>>
> That's a good idea.  We could also have a simple "noop" type provider that at least registers with the core but never claims any devices.  This would at least verify the build/install, and provider-load by libibverbs.
>
> Steve.
>

noop is good for testing. A true provider would make sure we haven't missed any headers.

Nicolas

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
