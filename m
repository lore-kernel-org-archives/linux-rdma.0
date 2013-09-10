From: Yijing Wang <wangyijing-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 4/6] IB/qib: Use pcie_set_mps() and pcie_get_mps() to
 simplify code
Date: Tue, 10 Sep 2013 09:04:53 +0800
Message-ID: <522E7035.6060404@huawei.com>
References: <1378732388-4508-1-git-send-email-wangyijing@huawei.com> <1378732388-4508-5-git-send-email-wangyijing@huawei.com> <32E1700B9017364D9B60AED9960492BC2119F081@FMSMSX107.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <32E1700B9017364D9B60AED9960492BC2119F081-AtyAts71sc9zLByeVOV5+bfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Marciniszyn, Mike" <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Bjorn Helgaas <bhelgaas-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Chris Metcalf <cmetcalf-kv+TWInifGbQT0dZR+AlfA@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, David Airlie <airlied-cv59FeDIM0c@public.gmane.org>, infinipath <infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Mark Einon <mark.einon-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Hanjun Guo <guohanjun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 2013/9/9 22:55, Marciniszyn, Mike wrote:
>> Subject: [PATCH 4/6] IB/qib: Use pcie_set_mps() and pcie_get_mps() to simplify
>> code
>>
>> Refactor qib_tune_pcie_caps() function, use pcie_set_mps() and
>> pcie_get_mps() to simply code. Because pci core caches the "PCI-E Max
>> Payload Size Supported" in pci_dev->pcie_mpss, so use that instead of
>> pcie_capability_read_word(). Remove the unused val2fld() and fld2val().
>>
> 
> I tested this patch as is and saw no issues.
> 
> The only thing I would suggest is that the new use of pcie_get_readrq/pcie_set_readrq() be reflected in the comments with an appropriate adjustment in the subject.

Hi Mike,
   Thanks for your tests very much! Ok, I will update the comments.

Thanks!
Yijing.

> 
> Mike
> 
>  
> 
> .
> 


-- 
Thanks!
Yijing

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
