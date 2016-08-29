From: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [RFCv2 00/15] RFCv2: Consolidated userspace RDMA library repo
Date: Mon, 29 Aug 2016 23:03:45 +0300
Message-ID: <aaf8d6ba-6dc2-51d9-b014-dcc10114079f@dev.mellanox.co.il>
References: <1471889618-1605-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <01dc01d1fcb0$a1dd3ed0$e597bc70$@opengridcomputing.com>
 <20160822214352.GB11695@obsidianresearch.com>
 <20160823185441.GA1233@obsidianresearch.com>
 <cabbd0a7-0918-a8dd-d1e5-0b079f0c4604@redhat.com>
 <c84de2a5-6526-c0a6-6535-519add3fbabb@dev.mellanox.co.il>
 <20160828182715.GA12783@obsidianresearch.com>
 <765b7e2d-51e0-98aa-60d1-26be35eb7a3d@dev.mellanox.co.il>
 <20160829163453.GC23557@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160829163453.GC23557-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, 'Devesh Sharma' <Devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, 'Hal Rosenstock' <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, 'Mike Marciniszyn' <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Moni Shoua' <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Sean Hefty' <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Tatyana Nikolova' <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Vladimir Sokolovsky' <vlad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Yishai Hadas' <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, yarong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 8/29/2016 7:34 PM, Jason Gunthorpe wrote:
> On Mon, Aug 29, 2016 at 03:07:48PM +0300, Yishai Hadas wrote:
>
> They are not self-contained. They have all sorts of inter-dependencies
> between each other and the kernel.

The dependencies are around the interfaces with the kernel and with 
applications, not in other parts. Using the extension mechanism a 
provider can extend both APIs without breaking other.

  Going forward do not expect the
> distros to just blindly take whatever tar ball you publish into their
> stable releases. That was special situation for the 'Technology
> Preview' stage in RHEL6.
>

No distro expects to take blindly and if it does it's bad.
AFAIK, there are testing and other actions done in in both distros and 
providers sides to make sure that any package is ready for a release.

> Remember, most of the code is dead, the maintainer is MIA or hasn't
> accepted a patch in months or years.

Agree, that's why I think that such dead providers code shouldn't be put 
and maintained with live providers, it doesn't make sense.
How many providers/libraries in this GIT are really active ?

> mlx4/mlx5 is an notable exeption. You and Doug should work out a
> reasonable appraoch. Maybe he takes your pulls directly, maybe you
> have co-commit access on Github (the team approach), something else?

We definitely need to close this point before going a head into any 
solution that might block a fast progress of accepting/merging new code 
of live/maintained projects as of libmlx4/5.

>>> This is already basically the case, you need to wait for Doug to take
>>> any libibverbs changes before you can push any provider feature
>>> change.

We should definitely find a way to escalate the review/acceptance of new 
features in libibverbs, need to take it with Doug as well.

>> This is incorrect, when Doug is taking into libibverbs, vendor code that is
>> ready can be taken immediately, the new approach might cause some extra
>> delays and slowness.
>
> I haven't seen you do that.

What are you talking about ? see last feature of TSO as an example, it 
was published in the list for both libibverbs and libmlx5, when Doug 
accepted the libiberbs part just an hour later I merged the libmlx5 part 
into its formal GIT at openfabrics and noted on that in the list.
Same was done for other features as of timestamping, rereg_mr, etc.
We must save this ability before going forward here.

> If you are pushing code into your provider that doesn't work with
> upstream libibverbs then you will be blacklisted by the distros. Do
> not do that.

Sure that we take *only* code that works with upstream libibverbs. Both 
libmlx4 and libmlx5 are *always* in a ready state for a release with 
latest libibverbs.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
