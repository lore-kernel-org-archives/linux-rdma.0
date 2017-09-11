From: "Steve Wise" <swise@opengridcomputing.com>
Subject: RE: [PATCH] RDMA/cxgb3: remove redundant first assignement of sqp
Date: Mon, 11 Sep 2017 09:28:14 -0500
Message-ID: <006201d32b0a$341b5470$9c51fd50$@opengridcomputing.com>
References: <20170911114231.22893-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <20170911114231.22893-1-colin.king@canonical.com>
Content-Language: en-us
Sender: kernel-janitors-owner@vger.kernel.org
To: 'Colin King' <colin.king@canonical.com>, 'Steve Wise' <swise@chelsio.com>, 'Doug Ledford' <dledford@redhat.com>, 'Sean Hefty' <sean.hefty@intel.com>, 'Hal Rosenstock' <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

> 
> From: Colin Ian King <colin.king@canonical.com>
> 
> sqp is being initialised when it is being declared and then updated
> a little later on making the first initialization redundant. Clean
> this up by initializing ptr and sqp at their declaration.
> 
> Cleans up warning: "warning: Value stored to 'sqp' during its
> initialization is never read"
> 
> Fixes: a58e58fafdff ("RDMA/cxgb3: Wrap the software send queue pointer as
> needed on flush")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Acked-by: Steve Wise <swise@opengridcomputing.com>

