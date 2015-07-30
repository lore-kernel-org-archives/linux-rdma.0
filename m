From: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v4 01/50] IB: Add CNP opcode enumeration.
Date: Thu, 30 Jul 2015 15:35:14 -0500 (CDT)
Message-ID: <alpine.DEB.2.11.1507301530490.6551@east.gentwo.org>
References: <20150730191631.25256.95511.stgit@phlsvslse11.ph.intel.com> <20150730191732.25256.85207.stgit@phlsvslse11.ph.intel.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150730191732.25256.85207.stgit-K+u1se/DcYrLESAwzcoQNrvm/XP+8Wra@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, 30 Jul 2015, Mike Marciniszyn wrote:

> This patch adds the value of the CNP opcode to the existing list of enumerated
> opcodes.

That is obvious and useless. Patches should have a meaningful
description and justify the changes.

Why do you add the CNP opcode and what in the world does it do? CNP is
what? And why do the other enum values not work for you?

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
