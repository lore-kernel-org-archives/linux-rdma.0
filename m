From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH rdma-core 0/5] Licensing and cleanup issues
Date: Wed, 28 Sep 2016 11:26:58 -0600
Message-ID: <20160928172658.GC22668@obsidianresearch.com>
References: <1475076789-14359-1-git-send-email-yishaih@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1475076789-14359-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Sep 28, 2016 at 06:33:04PM +0300, Yishai Hadas wrote:
> Look at ccan/config.h I just hard coded few required HAVE_XXX which
> expects to be available in Linux/distros environment.
> In case you think that it should be changed to be set dynamically with cmake please
> make the relevant changes as you are more familiar by that time with cmake.

I checked and we are safe to wire these constants in
buildlib/config.h.in - they are supported by all configurations I test
for.

I updated the sample patch I sent you and added on to fix the mixmax_t
issues.

https://github.com/jgunthorpe/rdma-plumbing/tree/for-yishai

Squish them down add add my Signed-off-by for all the cmake stuff

FYI, of you rebase your license_cleanup branch the PR on github will
update to reflect the revisions, no need for a new PR.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
