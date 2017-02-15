From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH v2 1/8] IB/SRP: Avoid using IB_MR_TYPE_SG_GAPS
Date: Wed, 15 Feb 2017 23:49:23 +0000
Message-ID: <1487202550.2666.10.camel@sandisk.com>
References: <20170214185636.29250-1-bart.vanassche@sandisk.com>
         <20170214185636.29250-2-bart.vanassche@sandisk.com>
         <cebcaeae-94a6-de82-cfc8-ce055b273836@grimberg.me>
         <1557361565.31861655.1487176647067.JavaMail.zimbra@redhat.com>
         <bd732aec-36d9-b53c-1bee-1793fc807a2a@grimberg.me>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <bd732aec-36d9-b53c-1bee-1793fc807a2a@grimberg.me>
Content-Language: en-US
Content-ID: <C7C79950173AE94F938EBF9D014BABF7@sandisk.com>
Sender: stable-owner@vger.kernel.org
To: "sagi@grimberg.me" <sagi@grimberg.me>, "loberman@redhat.com" <loberman@redhat.com>
Cc: "leonro@mellanox.com" <leonro@mellanox.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "israelr@mellanox.com" <israelr@mellanox.com>, "yuval.shaia@oracle.com" <yuval.shaia@oracle.com>, "markb@mellanox.com" <markb@mellanox.com>, "stable@vger.kernel.org" <stable@vger.kernel.org>, "maxg@mellanox.com" <maxg@mellanox.com>, "dledford@redhat.com" <dledford@redhat.com>
List-Id: linux-rdma@vger.kernel.org

On Wed, 2017-02-15 at 18:55 +0200, Sagi Grimberg wrote:
> Bart, I think the change I suggested is still needed regardless,
> do you agree?

I'm not sure. I have not yet had a close look at that part of the mlx5 driver.

Bart.
