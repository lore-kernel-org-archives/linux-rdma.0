From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH 6/8] IB/mlx5/hmm: add mlx5 HMM device initialization and
 callback v3.
Date: Tue, 21 Jul 2015 10:06:09 -0600
Message-ID: <20150721160609.GB25291@obsidianresearch.com>
References: <1437159665-6612-1-git-send-email-jglisse@redhat.com>
 <1437159665-6612-7-git-send-email-jglisse@redhat.com>
 <55AE2431.20105@mellanox.com>
 <1450090324.1616771.1437491699456.JavaMail.zimbra@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1450090324.1616771.1437491699456.JavaMail.zimbra-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jerome Glisse <jglisse-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Christophe Harle <charle-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Duncan Poole <dpoole-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Sherry Cheung <SCheung-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Subhash Gutti <sgutti-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, John Hubbard <jhubbard-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Mark Hairgrove <mhairgrove-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Lucien Dunning <ldunning-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Cameron Buschardt <cabuschardt-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Arvind Gopalakrishnan <arvindg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Shachar Raindel <raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Jul 21, 2015 at 11:14:59AM -0400, Jerome Glisse wrote:
> This is a rebase error. But the #error is there for a purpose the HMM
> would not work mid way so if anyone if bisecting up through that i would
> rather error out at compilation.

Add the kconfig option last not first?

Also, can you use 'if (IS_ENABLED(XXX))' as much as possible? Some of
the existing ODP checks looked like it should use that as well..

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
