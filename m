From: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [RFCv2 00/15] RFCv2: Consolidated userspace RDMA library repo
Date: Mon, 29 Aug 2016 15:07:48 +0300
Message-ID: <765b7e2d-51e0-98aa-60d1-26be35eb7a3d@dev.mellanox.co.il>
References: <1471889618-1605-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <01dc01d1fcb0$a1dd3ed0$e597bc70$@opengridcomputing.com>
 <20160822214352.GB11695@obsidianresearch.com>
 <20160823185441.GA1233@obsidianresearch.com>
 <cabbd0a7-0918-a8dd-d1e5-0b079f0c4604@redhat.com>
 <c84de2a5-6526-c0a6-6535-519add3fbabb@dev.mellanox.co.il>
 <20160828182715.GA12783@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160828182715.GA12783-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, 'Devesh Sharma' <Devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, 'Hal Rosenstock' <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, 'Mike Marciniszyn' <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Moni Shoua' <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Sean Hefty' <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Tatyana Nikolova' <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Vladimir Sokolovsky' <vlad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Yishai Hadas' <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, yarong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 8/28/2016 9:27 PM, Jason Gunthorpe wrote:
> On Sun, Aug 28, 2016 at 07:14:31PM +0300, Yishai Hadas wrote:
>
>> Today each vendor manages its code and is not exposed to bugs/issues in
>> other vendors. Moving to a consolidate rpm might cause that any bug fix in
>> one component will force a new release of all other stuff without any real
>> reason. Introducing such a dependency might even delay/block a release
>> without any justification.
>
> We already went over this with Steve, and the consensus was this isn't
> a practical problem.
>
> Please read the thread from here:
>
> https://www.spinics.net/lists/linux-rdma/msg37813.html

Already read it, still issue is open, any major bug fix in one vendor 
code might require a new package, comparing current situation that 
components are self-contained.

> Remember, by the time we get to the provider level there are already
> often dependencies in the kernel and libibverbs that need to be met by
> the distro, so it has rarely been the case of 'just grab my libprovider and
> you are good'

Each commit today to libibverbs must maintain compatibility with other 
vendors and can't break one of, I don't believe that this is going to be 
changed by that model.

>> I believe that we agree that each maintainer should be independent to
>> review/accept relevant code to his component and make sure that his code is
>> fully tested and ready for a release in any given time.
>
> The model is exactly the same as the kernel, which is proven to work,
> and does expect that all patches are release ready.

The kernel is managed by pull requests to Linus from few maintainers, it 
has a clear cycle of time frames for releases, etc.

Are you talking about same model that each maintainer will maintain his 
GIT and upon known time-frames will ask the main maintainer (who ever 
that will be) to take from their gits ? today the cycles in user space 
for such a flow are not defined, moving to that model in user space 
without a well defined process might be a very bad idea that will slow 
the process of having things formally upstream.


>> Put all code in one big umbrella letting only one person to accept code is
>> not a good idea which might slow the process of accepting new code and
>> features.
>
> This is already basically the case, you need to wait for Doug to take
> any libibverbs changes before you can push any provider feature
> change.

This is incorrect, when Doug is taking into libibverbs, vendor code that 
is ready can be taken immediately, the new approach might cause some 
extra delays and slowness.

In addition, there are changes in a provider code that are not depend on 
libibverbs, like bug fixes, internal enhancements, etc. No reason to 
wait for a slot from Doug, changes can be taken when they are ready.

> If this really concerns you then propose a maintainer team scheme -
> eg hosting this on github would allow for that.

The maintaining issues as described above are not solved by some extra 
github.

>> In addition, need to consider that there are few distros which have releases
>> in different times, the flexibility to take a specific component based on
>> its readiness and importance is a vital
>> point that must be saved as done today.
>
> Again, it doesn't matter. The distros will take from upstream whenever
> they are ready and upstream is 'continuously releasable'. This way the
> distros can get everything and not have to hunt down 15 different git
> trees randomly sprinkled across the internet

Every one can build a local GIT that points to remote upstream GITs and 
pull latest code in one command.

We must save the development/acceptance process flexible and fast and 
not put some extra barriers that may slow it in the way.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
