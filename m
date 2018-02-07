From: Hal Rosenstock <hal@dev.mellanox.co.il>
Subject: Re: [PATCH v3] Documentation/ABI: update infiniband sysfs interfaces
Date: Wed, 7 Feb 2018 06:49:04 -0500
Message-ID: <22426e9d-2ffb-b155-beca-2fbf2b300f3e@dev.mellanox.co.il>
References: <20180207045955.GA31749@mordor.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180207045955.GA31749@mordor.localdomain>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Aishwarya Pant <aishpant@gmail.com>, Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>, Greg KH <gregkh@linuxfoundation.org>
Cc: Julia Lawall <julia.lawall@lip6.fr>
List-Id: linux-rdma@vger.kernel.org

On 2/6/2018 11:59 PM, Aishwarya Pant wrote:
> Add documentation for core and hardware specific infiniband interfaces.
> The descriptions have been collected from git commit logs, reading
> through code and data sheets. Some drivers have incomplete doc and are
> annotated with the comment '[to be documented]'.
> 
> Signed-off-by: Aishwarya Pant <aishpant@gmail.com>

Thanks. Looks good to me (the device neutral parts of this which I
reviewed).

Nice work!

Reviewed-by: Hal Rosenstock <hal@mellanox.com>
