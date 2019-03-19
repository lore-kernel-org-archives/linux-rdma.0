From: Boris Pismenny <borisp@mellanox.com>
Subject: Re: [PATCH] net: mlx5: Add a missing check on idr_find
Date: Tue, 19 Mar 2019 15:00:45 +0000
Message-ID: <e5610b7a-2aa8-be54-a559-16106b4c3cca@mellanox.com>
References: <20190318221924.7034-1-pakki001@umn.edu>
 <e48d6cc9-9bb2-47fc-ec04-eceecbe6d91e@mellanox.com>
 <20190319143507.GO4823@mtr-leonro.mtl.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190319143507.GO4823@mtr-leonro.mtl.com>
Content-Language: en-US
Content-ID: <12252F3B82AAD142A7066BB416C5C6C0@eurprd05.prod.outlook.com>
Sender: netdev-owner@vger.kernel.org
To: Leon Romanovsky <leon@kernel.org>
Cc: Aditya Pakki <pakki001@umn.edu>, "kjlu@umn.edu" <kjlu@umn.edu>, Saeed Mahameed <saeedm@mellanox.com>, "David S. Miller" <davem@davemloft.net>, Ilya Lesokhin <ilyal@mellanox.com>, Wei Yongjun <weiyongjun1@huawei.com>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

Hi Leon,


On 3/19/2019 4:35 PM, Leon Romanovsky wrote:
> On Tue, Mar 19, 2019 at 01:41:49PM +0000, Boris Pismenny wrote:
>>
>>
>> On 3/19/2019 12:18 AM, Aditya Pakki wrote:
>>> idr_find() can return a NULL value to 'flow' which is used without a ch=
eck.
>>> The patch adds a check to avoid potential NULL pointer dereference.
>>
>> Did you encounter this in practice?
>> This flow you are suggesting shouldn't be possible, because the handle
>> is always there until the socket is destroyed in sk_destruct.
>>
>> But, I wouldn't mind some defensive coding here.
>> Maybe also a WARN_ONCE :)
>>
>> Could you also release buf in case of an error returned from
>> mlx5_fpga_sbu_conn_sendmsg below?
>> Otherwise, I could submit a patch for this.
>=20
> Boris,
>=20
> Can you please invest ten seconds to read previous emails prior to answer=
ing?
> https://lkml.org/lkml/2019/3/19/36
>=20
The fix you suggested is valid and should be addressed as well.

I didn't comment on your reply, but it doesn't mean that I disagree.
