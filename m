From: "Steve Wise" <swise@opengridcomputing.com>
Subject: RE: [PATCH 1/2] RDMA/uverbs: Fix the check for port number
Date: Thu, 13 Jul 2017 15:24:39 -0500
Message-ID: <01a201d2fc16$0dd293f0$2977bbd0$@opengridcomputing.com>
References: <1499974658-6180-1-git-send-email-mustafa.ismail@intel.com> <1499974658-6180-2-git-send-email-mustafa.ismail@intel.com>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <1499974658-6180-2-git-send-email-mustafa.ismail@intel.com>
Content-Language: en-us
Sender: stable-owner@vger.kernel.org
To: 'Mustafa Ismail' <mustafa.ismail@intel.com>, linux-rdma@vger.kernel.org
Cc: dledford@redhat.com, linux-kernel@vger.kernel.org, stable@vger.kernel.org, gregkh@linuxfoundation.org, shiraz.saleem@intel.com
List-Id: linux-rdma@vger.kernel.org

> The port number is only valid if IB_QP_PORT is set in the mask.
> So only check port number if it is valid to prevent modify_qp from
> failing due to an invalid port number.
> 
> Fixes: 5ecce4c9b17b("Check port number supplied by user verbs cmds")
> Signed-off-by: Mustafa Ismail <mustafa.ismail@intel.com>

Looks good.

Reviewed-by: Steve Wise <swise@opengridcomputing.com>
