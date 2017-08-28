From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH] i40iw: make some structures const
Date: Mon, 28 Aug 2017 19:19:01 -0400
Message-ID: <1503962341.52034.12.camel@redhat.com>
References: <1503937283-15549-1-git-send-email-bhumirks@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1503937283-15549-1-git-send-email-bhumirks@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Bhumika Goyal <bhumirks@gmail.com>, julia.lawall@lip6.fr, faisal.latif@intel.com, shiraz.saleem@intel.com, sean.hefty@intel.com, hal.rosenstock@gmail.com, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Mon, 2017-08-28 at 21:51 +0530, Bhumika Goyal wrote:
> Make some structures const as they are only used during a copy
> operation.
> 
> Signed-off-by: Bhumika Goyal <bhumirks@gmail.com>

Thanks, applied.

-- 
Doug Ledford <dledford@redhat.com>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
