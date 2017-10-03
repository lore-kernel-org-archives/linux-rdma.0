From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RDMA community con call summary
Date: Tue, 3 Oct 2017 06:31:27 -0400
Message-ID: <a78c831b-ab6b-f816-208c-00d138bc649a@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Marciniszyn, Mike" <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi folks,

This is a summary of the recent RDMA community conference call. These 
notes come from Leon with additions from me.

 > - Doug: Explain new process used in 4.14, feed back?

Things are going well for 4.14, so far. The process is working well, but 
it's just a start. The hope is that things continue going forward as 
they are.

 > - Leon: Explain how Mellanox is handling net-next coordination and
 >     timing of net tree acceptance vs rdma tree acceptance

The shared pull request concept perhaps was a bit misleading for some of 
those on the call. Leon offered a few words of explanation:

It seems that RoCE/iWARP vendors don't need something so complex. In 
general the kernel development community assumes that patches are 
generated against one tree. The netdev or rdma-next in our case. The 
RoCE/iWARP drivers have a common part in the netdev tree, but also many 
visible, and at times controversial changes in the RDMA tree. For 
instance, feature A developed for netdev, and feature B for RDMA. These 
could cause a merge conflict for Linus when he takes both trees from 
their respective maintainers.

How to avoid problems:

1. Prepare your (rdma + netdev) submission queue in advance for the next 
cycle.

2. Perform a merge test to check for conflicts. If you don't find any, 
you can relax and not have to worry about shared code.

3. If there are conflicts, re-organize the submission so that netdev 
patches are first. Then send a pull request to both maintainers with the 
minimal number of patches. They should still be the same topic, and must 
be complete (no half feature). This pull request needs to be high 
quality, as in already reviewed, commented on, and tested. The idea is 
it should be able to be pulled as is.

4. The shared pull request should be based on Linus' tree, one of the RC 
releases.

Now if your RDMA patches depend on a netdev feature, a shared pull 
request will probably not be necessary. The entire feature should be 
able to be submitted to RDMA (Doug) while CCing the netdev folks (Dave), 
make it clear you intend for Doug to take the patches.

 > - Jason/All: QA coordination and ensuring QA cycles are well spent,
 >     eg 'what to test'

for-rc: QA should test Linus' master branch and not rely on Doug's 
for-rc tag.

for-next: QA should test this tag.

Doug's Github is a private repo, don't rely on it for anything. It is a 
working tree and an early access preview of what will be showing up on 
Kernel.org.

 > - Distributing patch acceptance, covering PTO periods, etc.
 > - Open mic period

For now Jason is being suggested as a co-maintainer with proper write 
access rights and eligible to send pull requests to Linus on behalf of 
the community. Jason is looking into how this could be possible and
should have an answer in 2-3 weeks.

The community call was a good step to getting things on track in the 
RDMA sub system. Leon and I are both in agreement that there should be a 
way for a true shared repository for the maintainer/co-maintainer. This 
means a repository that allows access by multiple folks (ie how 
rdma-core works). The mechanics of how this all is going to work is also 
something that should be transparent. It should be discussed on the list 
so everyone knows exactly how things are going to be working.

Anything that is missing please comment.

Thanks.

-Denny (Intel) and Leon (Mellanox)
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
