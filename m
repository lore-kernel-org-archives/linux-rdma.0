From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: WARNING on drivers/infiniband/core/verbs.c:1975
 __ib_drain_sq+0x182/0x1c0 [ib_core]
Date: Fri, 24 Mar 2017 21:44:26 -0400
Message-ID: <1490406266.2404.34.camel@redhat.com>
References: <1457714996.31424605.1488696068958.JavaMail.zimbra@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1457714996.31424605.1488696068958.JavaMail.zimbra-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yi Zhang <yizhan-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Sun, 2017-03-05 at 01:41 -0500, Yi Zhang wrote:
> Hi
> 
> I get bellow WARNING when trying to connect nvmet with nvmecli.
> 
> Steps I used:
> On target:
> 1. Use nvmetcli setup nvmet with below json 
> {
>   "hosts": [
>     {
>       "nqn": "hostnqn"
>     }
>   ], 
>   "ports": [
>     {
>       "addr": {
>         "adrfam": "ipv4", 
>         "traddr": "172.31.40.4", 

For testing ocrdma, you need to use the 172.31.45.0 network vlan.  For
testing other RoCE cards in our lab, you can use either the 43 or 45
vlans, but you shouldn't use the untagged interface for RoCE tests.

-- 
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
   
Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
