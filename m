From: Bjorn Helgaas <bhelgaas-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 4/6] IB/qib: Use pcie_set_mps() and pcie_get_mps() to
 simplify code
Date: Fri, 4 Oct 2013 14:49:39 -0600
Message-ID: <CAErSpo41332ti7m=BTSWik_DrGzpqNOc0zwDde_iYmr696gZUQ@mail.gmail.com>
References: <1378732388-4508-1-git-send-email-wangyijing@huawei.com>
 <1378732388-4508-5-git-send-email-wangyijing@huawei.com> <32E1700B9017364D9B60AED9960492BC2119F081@FMSMSX107.amr.corp.intel.com>
 <20130924203806.GA9302@google.com> <32E1700B9017364D9B60AED9960492BC211AE5BF@FMSMSX107.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <32E1700B9017364D9B60AED9960492BC211AE5BF-AtyAts71sc9zLByeVOV5+bfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Marciniszyn, Mike" <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Yijing Wang <wangyijing-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Chris Metcalf <cmetcalf-kv+TWInifGbQT0dZR+AlfA@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, David Airlie <airlied-cv59FeDIM0c@public.gmane.org>, infinipath <infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Mark Einon <mark.einon-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Hanjun Guo <guohanjun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Sep 30, 2013 at 8:56 AM, Marciniszyn, Mike
<mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
>>
>> Is something like the following what you had in mind?  If so, I can
>> just queue it up.  Otherwise, I'll wait for Yijing to post a v2 patch.
>>
>>
>> IB/qib: Use pcie_set_mps() and pcie_get_mps() to simplify code
>>
>> From: Yijing Wang <wangyijing-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
>>
>> Refactor qib_tune_pcie_caps().  Use pcie_get_mps(), pcie_set_mps(),
>> pcie_get_readrq(), and pcie_set_readrq() to simplify the code.  The PCI
>> core caches the "PCIe Max Payload Size Supported" in pci_dev->pcie_mpss,
>> so use that instead of pcie_capability_read_word().  Remove the unused
>> val2fld() and fld2val().
>>
>> Signed-off-by: Yijing Wang <wangyijing-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
>> Signed-off-by: Bjorn Helgaas <bhelgaas-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
>
> This works!
>
> Go ahead and queue it up.

Applied to my pci/yijing-mps-v1 branch with your ack:

http://git.kernel.org/cgit/linux/kernel/git/helgaas/pci.git/commit/?h=pci/yijing-mps-v1&id=0ce0e62f1f7893f983a8f61bc8f5306e80d520b1

Let me know if that's not what you had in mind.  Thanks!

Bjorn
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
