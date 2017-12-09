From: Fengguang Wu <fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: 0-day service tree move for rdma
Date: Sat, 9 Dec 2017 10:26:16 +0800
Message-ID: <20171209022616.mqpubc6aib5rtcgf@wfg-t540p.sh.intel.com>
References: <20171209001111.GA23222@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171209001111.GA23222-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: kbuild-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, LKP <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Jason,

On Fri, Dec 08, 2017 at 05:11:11PM -0700, Jason Gunthorpe wrote:
>Hi Fengguang,
>
>RDMA has moved to a co-maintainer and shared tree model for our
>official repo, can you update the 0-day build service information?

My pleasure!

>I looked at your lktp git tree and came up with the patch below, not
>sure it is totally right, and wasn't able to check 'subsystems'..

The subsystems annotation are to help find the most relevant base git
tree to git-am LKML patches.

For example,

        [PATCH] ib: do some change

If your tree has "ib" included in the subsystems field, then the patch
will have higher match score to your git tree.

>The main thing is we'd like to test all branches in rdma.git, and
>loose patches posted to our mailing list (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)
>and both of us would receive email'd build completion notifications.

OK.

>Thank you for running this service, we in the RDMA community have
>found it valuable!

Thank you for your appreciations!

>+git_am_branch: for-next
>+integration_testing_branches: for-next

integration_testing_branches automatically indicates git_am_branch.
The former also means the branch is merge tested by linux-next.

So I'll remove the git_am_branch line.

Thanks,
Fengguang
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
