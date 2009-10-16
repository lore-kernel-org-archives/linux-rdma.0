From: Roland Dreier <rdreier@cisco.com>
Subject: Re: kernel BUG at drivers/pci/intel-iommu.c:1278
Date: Fri, 16 Oct 2009 11:58:36 -0700
Message-ID: <ada63afxj1f.fsf@cisco.com>
References: <4AD8A393.3040907@scalableinformatics.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S932548AbZJPTH2@vger.kernel.org>
In-Reply-To: <4AD8A393.3040907@scalableinformatics.com> (Joe Landman's message
	of "Fri, 16 Oct 2009 12:47:15 -0400")
Sender: linux-kernel-owner@vger.kernel.org
To: landman@scalableinformatics.com
Cc: linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, Anand Babu Periasamy <ab@gluster.com>
List-Id: linux-rdma@vger.kernel.org


 > Anything I should look for?  I know 2.6.28 is not being developed any
 > further.  Should I start looking at 2.6.31 to help with this?

Definitely looking at 2.6.31 or even 2.6.32-rc kernels to see if this
still happens would be a good idea.  I've not done much IB work with
VT-d enabled, but the fact that the BUG() is in drivers/pci seems to
indicate that the problem is fairly likely to be some internal
corruption in the intel_iommu code, caused by a bug there, rather than
anything IB related.

 - R.
