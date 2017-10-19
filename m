From: Yi Zhang <yi.zhang-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: nvmeof rdma regression issue on 4.14.0-rc1 (or maybe mlx4?)
Date: Thu, 19 Oct 2017 19:13:43 +0800
Message-ID: <212f5da2-b0e2-23aa-d517-7512d656dec8@redhat.com>
References: <1735134433.8514119.1505997532669.JavaMail.zimbra@redhat.com>
 <1215229914.8516804.1505998051674.JavaMail.zimbra@redhat.com>
 <20170921144421.GA15285@infradead.org>
 <47493aa0-4cad-721b-4ea2-c3b2293340aa@grimberg.me>
 <e8aa9f2e-14b1-23f0-f672-07a913842c9d@redhat.com>
 <20170924103426.GB25094@mtr-leonro.local>
 <4d0e27f2-99e4-ffc7-18a5-e5757c27dad4@redhat.com>
 <4faccebf-7fcf-58b9-1605-82ee9acc652b@grimberg.me>
 <e44f4640-44b2-4692-ca57-08f9ebf4da2c@redhat.com>
 <729c512f-55ff-25e4-6dd9-8b4dcc31bb8d@grimberg.me>
 <ff355fcf-5089-f297-d3fa-9b86d133236b@redhat.com>
 <6d639dd4-9366-2ecf-b49e-751c7a167528@grimberg.me>
 <64135330-a62d-87b8-c805-6b52fd40bf81@redhat.com>
 <62eea88b-caa4-5799-3d8f-8d8789879aa8@grimberg.me>
 <0561ed58-7104-d8b6-1709-ea181ac493f5@redhat.com>
 <0069d38b-efb7-0d41-ff0f-2087572cb22f@grimberg.me>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <0069d38b-efb7-0d41-ff0f-2087572cb22f-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Tariq Toukan <tariqt-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



On 10/19/2017 05:44 PM, Sagi Grimberg wrote:
>
>> Hi Sagi
>> With this patch, no such error log found on host side,
>
>
> Awsome. that's the culprit...
>
>> but I found there is no nvme0n1 device node even get "nvme nvme0: 
>> Successfully reconnected" on host.
>
> That is expected because you did not persist a namespace UUID
> which caused the kernel to generate a random one. That confused
> the host as it got the same namespace ID with a different UUID.
>
> Can you please set a uuid when you rerun the test?
>
I tried add uuid filed on rdma.json, it works well now.

[root@rdma-virt-00 ~]$ cat /etc/rdma.json
{
   "hosts": [
     {
       "nqn": "hostnqn"
     }
   ],
   "ports": [
     {
       "addr": {
         "adrfam": "ipv4",
         "traddr": "172.31.0.90",
         "treq": "not specified",
         "trsvcid": "4420",
         "trtype": "rdma"
       },
       "portid": 2,
       "referrals": [],
       "subsystems": [
         "testnqn"
       ]
     }
   ],
   "subsystems": [
     {
       "allowed_hosts": [],
       "attr": {
         "allow_any_host": "1"
       },
       "namespaces": [
         {
           "device": {
             "nguid": "ef90689c-6c46-d44c-89c1-4067801309a8",
             "path": "/dev/nullb0",
             "uuid": "00000000-0000-0000-0000-000000000001"
           },
           "enable": 1,
           "nsid": 1
         }
       ],
       "nqn": "testnqn"
     }
   ]
}

> _______________________________________________
> Linux-nvme mailing list
> Linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
> http://lists.infradead.org/mailman/listinfo/linux-nvme

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
