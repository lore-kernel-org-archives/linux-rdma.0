From: Dennis Dalessandro <dennis.dalessandro@intel.com>
Subject: Re: [PATCH] infiniband/hfil: drop pci_link_reset()
Date: Mon, 19 Dec 2016 10:54:59 -0500
Message-ID: <e6f22b2d-faf7-390a-ca4d-564c6d0841b8@intel.com>
References: <1482129996-19255-1-git-send-email-caoj.fnst@cn.fujitsu.com>
 <1482129996-19255-2-git-send-email-caoj.fnst@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-pci-owner@vger.kernel.org>
In-Reply-To: <1482129996-19255-2-git-send-email-caoj.fnst@cn.fujitsu.com>
Sender: linux-pci-owner@vger.kernel.org
To: Cao jin <caoj.fnst@cn.fujitsu.com>, linux-rdma@vger.kernel.org
Cc: dledford@redhat.com, sean.hefty@intel.com, hal.rosenstock@gmail.com, linux-pci@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On 12/19/2016 01:46 AM, Cao jin wrote:
> In AER recovery, pci_error_handlers.link_reset() is never called,
> drop it now.
>
> Signed-off-by: Cao jin <caoj.fnst@cn.fujitsu.com>

Is this part of a larger patch series? If the function is never called 
it should be removed from struct pci_error_handlers should it not? Then 
in the same series be removed from all the drivers.

Probably should check with the folks on linux-pci about this though.

-Denny
