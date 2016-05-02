From: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: Status of RXE/Soft-RoCE driver?
Date: Mon, 2 May 2016 13:03:12 +0300
Message-ID: <572725E0.4090303@dev.mellanox.co.il>
References: <CAANLjFq+6qu7kD75yOmVuztvE-6cbvhfjFOmGAy9i_43Cfdz7A@mail.gmail.com>
 <5721F149.1090004@grimberg.me> <20160428115653.GB21343@leon.nu>
 <CAJ3xEMjz-VLvaRvVFBtNc+9GDppW6qjw_5KwZvPRDi1RdUnsgQ@mail.gmail.com>
 <5722C24B.6020108@redhat.com> <20160429051755.GC774@leon.nu>
 <a1d504ff-716c-210a-7114-517577d2e0fa@redhat.com>
 <20160429205434.GA11286@obsidianresearch.com>
 <20160430072847.GB25593@leon.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160430072847.GB25593-2ukJVAZIZ/Y@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, Robert LeBlanc <robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Tzahi Oved (tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org)" <tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 4/30/2016 10:28 AM, Leon Romanovsky wrote:
> On Fri, Apr 29, 2016 at 02:54:34PM -0600, Jason Gunthorpe wrote:
>> On Fri, Apr 29, 2016 at 11:06:46AM -0400, Doug Ledford wrote:
>>
>>>> These patches are long time here in mailing list and they were reviewed as
>>>> all other patches in this mailing list.
>>>
>>> That's not true.  The RSS patches in particular tend to get no review.
>>> No one appears to care about them.  V1 was posted way back last year and
>>> no one had anything to say about them.  I don't know when V2 was, it's
>>> no longer in my mailbox.  Then v3 has been on the list for 12 days and
>>> again, no one has responded.  No review at all does not mean
>>> automatically accepted.
>>
>> During the Collab summit I thought we reached a rough consensus that
>> these sorts of uAPI changes to the common multi-vendor API would go
>> through a more rigorous process and those who are proposing them would
>> actively seek a multi-vendor sign off instead of simply dumping them
>> on the list. Liran nominated himself and the OFVWG to act as a
>> forum. I recommend we let that process get going and do it's work.
>>
>> Further, I also thought we reached a rough consensus that we'd shunt
>> some of this stuff to the driver specific uAPI channel to reduce this
>> continual churn on the common multi-vendor API for currently
>> driver-specific features. Drivers can implement their unique features
>> and sanely export them through the kernel without so much pain. The
>> uAPI 2.0 concepts from all parties have been heavily influenced by
>> this idea.
>>
>> Certainly, if patches cannot attract any review or interest from the
>> community as part of the core API then I'd say that is an excellent
>> sign they should be shunted to a driver specific channel.
>>
>> There is more flexability in user space to make mistakes with the
>> libibverbs/etc API, and more options to provide access to these kind
>> of services. For instance I really wonder if integrating into
>> libibverbs is really the right home to trial a broad range of brand
>> new UD offload focused features.
>
> Jason,
> It is **respin** of patches which were with us for **more than year**, it is
> enough time to all participants and maintainer to say their word.
>

Hi Doug,

We've gone through the following stages for this RSS patch set already:
1) First series of patch set for RSS verbs was submitted at 8 May 2012: 
http://www.spinics.net/lists/linux-rdma/msg11746.html.
2) After *long* discussions with the community, and after addressing the 
community comments both on the mailing list and f2f discussions at OFA 
developers workshop at 2012,  we built an abstract and generic new API.
3) In order to get wider acceptance to the new proposal *before* we 
implement, we've posted an RFC at Mon, 11 May 2015, a year (!) ago
4) Additionally, The API was presented by Liran and AlexV from Mellanox 
in OFAWG meeting at Jun 9 2015. Link to the invite: 
http://lists.openfabrics.org/pipermail/ofvwg/2015-June/000077.html, Link 
to the presentation: 
http://lists.openfabrics.org/pipermail/ofvwg/attachments/20150609/30f73a1d/attachment-0001.pdf
5) Following discussion over the mailing list and responding to all 
feedback we've received, presentation at OFVWG we moved forward and 
invested large effort to implement and posted the patch series at Oct 18 
2015: https://www.mail-archive.com/linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org/msg28611.html
6) The new API was presented once more by Tzahi from Mellanox at last 
OFA 2016 workshop in the summit as part of the User Mode Ethernet Verbs 
presentation: 
https://www.openfabrics.org/images/eventpresos/2016presentations/205EthernetVerbs.pdf
7) Following more discussion at the 2016 workshop we were asked to 
resubmit V3 patch-set. We did so at 17 April 2016: 
http://www.spinics.net/lists/linux-rdma/msg35119.html

The above stages are way over the latest collaboration summit agreed 
guidelines for submitting new functionality and enriching the API. There 
is not technical feedback on the table that we left behind and did not 
address to make the API vendor agnostic and abstract.

Please accept.
Yishai
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
