From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH rdma-core] rpm: BR: python for libmlx5
Date: Wed, 22 Mar 2017 21:47:28 -0600
Message-ID: <20170323034728.GA24582@obsidianresearch.com>
References: <20170323021246.35786-1-jarod@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170323021246.35786-1-jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Mar 22, 2017 at 10:12:46PM -0400, Jarod Wilson wrote:
> The relpath python script added in commit 07764bc805ba requires python to
> run, thus we must BuildRequires: python in the rpm spec files, or the
> build will fail in minimal environments (such as mock).
> 
> Fixes: 07764bc805ba ("mlx5: Export mlx5 direct verbs interface")
> CC: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>  rdma-core.spec        | 1 +
>  redhat/rdma-core.spec | 1 +
>  2 files changed, 2 insertions(+)

I suspect we need to add python to debian/control as well, for the
same reasons.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
