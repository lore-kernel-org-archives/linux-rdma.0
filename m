From: Nathan Chancellor <natechancellor@gmail.com>
Subject: [PATCH v2] IB/rxe: Avoid implicit enum conversions in rxe_init functions
Date: Wed, 26 Sep 2018 22:01:57 -0700
Message-ID: <20180927050156.20023-1-natechancellor@gmail.com>
References: <20180927011010.8373-1-natechancellor@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180927011010.8373-1-natechancellor@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Moni Shoua <monis@mellanox.com>, Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, Nick Desaulniers <ndesaulniers@google.com>, Nathan Chancellor <natechancellor@gmail.com>
List-Id: linux-rdma@vger.kernel.org

Clang warns when an emumerated type is implicitly converted to another.

drivers/infiniband/sw/rxe/rxe.c:106:27: warning: implicit conversion
from enumeration type 'enum rxe_device_param' to different enumeration
type 'enum ib_atomic_cap' [-Wenum-conversion]
        rxe->attr.atomic_cap                    = RXE_ATOMIC_CAP;
                                                ~ ^~~~~~~~~~~~~~
drivers/infiniband/sw/rxe/rxe.c:131:22: warning: implicit conversion
from enumeration type 'enum rxe_port_param' to different enumeration
type 'enum ib_port_state' [-Wenum-conversion]
        port->attr.state                = RXE_PORT_STATE;
                                        ~ ^~~~~~~~~~~~~~
drivers/infiniband/sw/rxe/rxe.c:132:24: warning: implicit conversion
from enumeration type 'enum rxe_port_param' to different enumeration
type 'enum ib_mtu' [-Wenum-conversion]
        port->attr.max_mtu              = RXE_PORT_MAX_MTU;
                                        ~ ^~~~~~~~~~~~~~~~
drivers/infiniband/sw/rxe/rxe.c:133:27: warning: implicit conversion
from enumeration type 'enum rxe_port_param' to different enumeration
type 'enum ib_mtu' [-Wenum-conversion]
        port->attr.active_mtu           = RXE_PORT_ACTIVE_MTU;
                                        ~ ^~~~~~~~~~~~~~~~~~~
drivers/infiniband/sw/rxe/rxe.c:151:24: warning: implicit conversion
from enumeration type 'enum rxe_port_param' to different enumeration
type 'enum ib_mtu' [-Wenum-conversion]
                                ib_mtu_enum_to_int(RXE_PORT_ACTIVE_MTU);
                                ~~~~~~~~~~~~~~~~~~ ^~~~~~~~~~~~~~~~~~~
5 warnings generated.

Use the appropriate values from the expected enumerated type so no
conversion needs to happen.

Reported-by: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
---

v1 -> v2:

* Don't cast, just use the expecting enumerated value directly, per
  Jason's request

 drivers/infiniband/sw/rxe/rxe.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/sw/rxe/rxe.c b/drivers/infiniband/sw/rxe/rxe.c
index 10999fa69281..2f4e57886b89 100644
--- a/drivers/infiniband/sw/rxe/rxe.c
+++ b/drivers/infiniband/sw/rxe/rxe.c
@@ -103,7 +103,7 @@ static void rxe_init_device_param(struct rxe_dev *rxe)
 	rxe->attr.max_res_rd_atom		= RXE_MAX_RES_RD_ATOM;
 	rxe->attr.max_qp_init_rd_atom		= RXE_MAX_QP_INIT_RD_ATOM;
 	rxe->attr.max_ee_init_rd_atom		= RXE_MAX_EE_INIT_RD_ATOM;
-	rxe->attr.atomic_cap			= RXE_ATOMIC_CAP;
+	rxe->attr.atomic_cap			= IB_ATOMIC_HCA;
 	rxe->attr.max_ee			= RXE_MAX_EE;
 	rxe->attr.max_rdd			= RXE_MAX_RDD;
 	rxe->attr.max_mw			= RXE_MAX_MW;
@@ -128,9 +128,9 @@ static void rxe_init_device_param(struct rxe_dev *rxe)
 /* initialize port attributes */
 static int rxe_init_port_param(struct rxe_port *port)
 {
-	port->attr.state		= RXE_PORT_STATE;
-	port->attr.max_mtu		= RXE_PORT_MAX_MTU;
-	port->attr.active_mtu		= RXE_PORT_ACTIVE_MTU;
+	port->attr.state		= IB_PORT_DOWN;
+	port->attr.max_mtu		= IB_MTU_4096;
+	port->attr.active_mtu		= IB_MTU_256;
 	port->attr.gid_tbl_len		= RXE_PORT_GID_TBL_LEN;
 	port->attr.port_cap_flags	= RXE_PORT_PORT_CAP_FLAGS;
 	port->attr.max_msg_sz		= RXE_PORT_MAX_MSG_SZ;
@@ -147,8 +147,7 @@ static int rxe_init_port_param(struct rxe_port *port)
 	port->attr.active_width		= RXE_PORT_ACTIVE_WIDTH;
 	port->attr.active_speed		= RXE_PORT_ACTIVE_SPEED;
 	port->attr.phys_state		= RXE_PORT_PHYS_STATE;
-	port->mtu_cap			=
-				ib_mtu_enum_to_int(RXE_PORT_ACTIVE_MTU);
+	port->mtu_cap			= ib_mtu_enum_to_int(IB_MTU_256);
 	port->subnet_prefix		= cpu_to_be64(RXE_PORT_SUBNET_PREFIX);
 
 	return 0;
-- 
2.19.0
