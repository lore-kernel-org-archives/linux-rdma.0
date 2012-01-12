From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH] IB/qib: detour pcie_caps for certain chip sets
Date: Wed, 11 Jan 2012 22:48:30 -0700
Message-ID: <20120112054830.GB32082@obsidianresearch.com>
References: <20120112030049.31831.62692.stgit@kop-dev-sles11-04.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20120112030049.31831.62692.stgit-hIFRcJ1SNwcXGO8/Qfapyjg/wwJxntczYPYVAmT7z5s@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Cc: roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Jan 11, 2012 at 10:00:49PM -0500, Mike Marciniszyn wrote:
> Commit 8d4548f2b ("IB/qib: Default some module parameters optimally")
> introduced an issue with older root complexes.  They cannot handle
> the pcie_caps of 0x51.

Should whatever this issue is be a general PCI fixup? Like broken MSI,
etc.

Might be nice to include what 0x51 tunes in the commit to aide other
peoole with the broken chipset :)

Isn't it necesary to check the PCI vendor as well as the devid?

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
