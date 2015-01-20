From: =?UTF-8?B?U8OpYmFzdGllbiBEdWd1w6k=?= <sebastien.dugue-6ktuUTfB/bM@public.gmane.org>
Subject: [PATCH 0/2] mstflint:
Date: Tue, 20 Jan 2015 10:44:56 +0100
Message-ID: <20150120104456.65fbce52@b012350-ux>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Adrian Chiris <adrianc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


  Hi,

  this tiny series addresses 2 things:

  - Fix the various dist-xxx Makefile targets

  - Install the mflash and mtcr libraries and headers so that applications
    can use them.



Sebastien Dugue (2):
  mstflint: Fix make dist-xx
  mstflint: Install mflash/mtcr libraries & headers

 cmdif/Makefile.am         |  2 +-
 mflash/Makefile.am        | 10 ++++++++--
 mft_utils/Makefile.am     |  3 ++-
 mstflint.spec.in          |  4 ++--
 mtcr_ul/Makefile.am       |  5 +++--
 reg_access/Makefile.am    |  5 +++--
 tools_layouts/Makefile.am |  4 +++-
 7 files changed, 22 insertions(+), 11 deletions(-)

-- 
1.8.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
