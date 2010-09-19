From: Irena Gannon <irena@mellanox.co.il>
Subject: [patch][tools[perftests] Add a -d <guid> option to
	enable	choosing a device to run on
Date: Sun, 19 Sep 2010 16:00:25 +0200
Message-ID: <E113D394D7C5DB4F8FF691FA7EE9DB443BF12865D0@MTLMAIL.mtl.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="_004_E113D394D7C5DB4F8FF691FA7EE9DB443BF12865D0MTLMAILmtlcom_"
Return-path: <ofw-bounces@lists.openfabrics.org>
Content-Language: en-US
List-Unsubscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ofw>,
	<mailto:ofw-request@lists.openfabrics.org?subject=unsubscribe>
List-Archive: <http://lists.openfabrics.org/pipermail/ofw>
List-Post: <mailto:ofw@lists.openfabrics.org>
List-Help: <mailto:ofw-request@lists.openfabrics.org?subject=help>
List-Subscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ofw>,
	<mailto:ofw-request@lists.openfabrics.org?subject=subscribe>
Sender: ofw-bounces@lists.openfabrics.org
Errors-To: ofw-bounces@lists.openfabrics.org
To: "ofw@lists.openfabrics.org" <ofw@lists.openfabrics.org>
Cc: "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

--_004_E113D394D7C5DB4F8FF691FA7EE9DB443BF12865D0MTLMAILmtlcom_
Content-Type: multipart/alternative;
	boundary="_000_E113D394D7C5DB4F8FF691FA7EE9DB443BF12865D0MTLMAILmtlcom_"

--_000_E113D394D7C5DB4F8FF691FA7EE9DB443BF12865D0MTLMAILmtlcom_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Signed-off-by: Irena Gannon (irena@mellanox.co.il<mailto:irena@mellanox.co.=
il>)

This patch adds a -d <guid> option to the tests to enable choosing a device=
 to run on.

Index: D:/Windows/MLNX_VPI/tools/perftests/user/send_bw/send_bw.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- D:/Windows/MLNX_VPI/tools/perftests/user/send_bw/send_bw.c             =
   (revision 6545)
+++ D:/Windows/MLNX_VPI/tools/perftests/user/send_bw/send_bw.c             =
(revision 6546)
@@ -38,6 +38,7 @@
 #include "get_clock.h"

 #include "perf_defs.h"
+#include "l2w.h"

 #define SIGNAL 1
 #define MAX_INLINE 400
@@ -73,13 +74,14 @@


 static struct pingpong_context *pp_init_ctx(unsigned size,int port,
-                                                                          =
    struct user_parameters *user_parm)
+                                                                          =
   struct user_parameters *user_parm, char* ib_devguid)
 {

                struct pingpong_context              *ctx;
                ib_api_status_t                                            =
    ib_status =3D IB_SUCCESS;
                size_t                                                     =
               guid_count;
                ib_net64_t                                                 =
         *ca_guid_array;
+             int                                                          =
                 guid_index =3D 0;



@@ -158,7 +160,28 @@
                 * Open only the first HCA
                 */
                /* Open the CA */
-              ib_status =3D ib_open_ca(ctx->al ,ca_guid_array[0] ,NULL,
+             if (ib_devguid)
+             {
+                             unsigned int i =3D 0;
+                             guid_index =3D -1;
+                             for (i =3D 0; i < guid_count; i++)
+                             {
+                                             char curr_dev[20];
+                                             sprintf(curr_dev, "0x%016I64x=
", ntohll(ca_guid_array[i]));
+                                             if (!_stricmp(ib_devguid, cur=
r_dev))
+                                             {
+                                                             guid_index =
=3D i;
+                                                             break;
+                                             }
+                             }
+                             if (guid_index =3D=3D -1)
+                             {
+                                             fprintf(stderr,"device with g=
uid %s was not found\n", ib_devguid);
+                                             return NULL;
+                             }
+             }
+
+             ib_status =3D ib_open_ca(ctx->al ,ca_guid_array[guid_index] ,=
NULL,
                                NULL,    //ca_context
                                &ctx->ca);

@@ -549,6 +572,7 @@
                printf("\n");
                printf("Options:\n");
                printf("  -p, --port=3D<port>         listen on/connect to =
port <port> (default 18515)\n");
+             printf("  -d, --ib-dev=3D<dev>        use IB device <device g=
uid> (default first device found)\n");
                printf("  -i, --ib-port=3D<port>      use port <port> of IB=
 device (default 1)\n");
                printf("  -c, --connection=3D<RC/UC>  connection type RC/UC=
/UD (default RC)\n");
                printf("  -m, --mtu=3D<mtu>           mtu size (default 102=
4)\n");
@@ -943,7 +967,7 @@
                struct pingpong_dest                     *my_dest;
                struct pingpong_dest                     *rem_dest;
                struct user_parameters                                user_=
param;
-              char                                                       *=
ib_devname =3D NULL;
+             char                                                       *i=
b_devguid =3D NULL;
                int                                                        =
   port =3D 18515;
                int                                                        =
   ib_port =3D 1;
                unsigned                                             size =
=3D 65536;
@@ -953,6 +977,8 @@
                WSADATA                                                    =
       wsaData;
                int                                                        =
   iResult;

+             SYSTEM_INFO si;
+             GetSystemInfo(&si);

                /* init default values to user's parameters */
                memset(&user_param, 0, sizeof(struct user_parameters));
@@ -998,7 +1024,7 @@
                                                ++user_param.use_event;
                                                break;
                                case 'd':
-                                              ib_devname =3D _strdup(optar=
g);
+                                             ib_devguid =3D _strdup(optarg=
);
                                                break;
                                case 'c':
                                                if (strcmp("UC",optarg)=3D=
=3D0)
@@ -1100,14 +1126,11 @@

                srand(GetCurrentProcessId() * GetTickCount());

-              //TODO: get pagesize from sysinfo
-              page_size =3D 4096;
+             page_size =3D si.dwPageSize;

-              //TODO:get the device names
-

                // init the context
-              ctx =3D pp_init_ctx(size, ib_port, &user_param);
+             ctx =3D pp_init_ctx(size, ib_port, &user_param, ib_devguid);
                if (!ctx)
                                return 1;

Index: D:/Windows/MLNX_VPI/tools/perftests/user/send_bw/SOURCES
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- D:/Windows/MLNX_VPI/tools/perftests/user/send_bw/SOURCES   (revision 65=
45)
+++ D:/Windows/MLNX_VPI/tools/perftests/user/send_bw/SOURCES               =
 (revision 6546)
@@ -11,7 +11,7 @@
                ..\perf_utils.c \
                send_bw.c

-INCLUDES=3D..;..\..\..\..\inc;..\..\..\..\inc\user
+INCLUDES=3D..;..\..\..\..\inc;..\..\..\..\inc\user;..\..\..\..\hw\mlx4\use=
r\hca;..\..\..\..\inc\complib

 RCOPTIONS=3D/I..\..\win\include

Index: D:/Windows/MLNX_VPI/tools/perftests/user/write_bw/SOURCES
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- D:/Windows/MLNX_VPI/tools/perftests/user/write_bw/SOURCES  (revision 65=
45)
+++ D:/Windows/MLNX_VPI/tools/perftests/user/write_bw/SOURCES              =
 (revision 6546)
@@ -11,7 +11,7 @@
                ..\perf_utils.c \
                write_bw.c

-INCLUDES=3D..;..\..\..\..\inc;..\..\..\..\inc\user
+INCLUDES=3D..;..\..\..\..\inc;..\..\..\..\inc\user;..\..\..\..\hw\mlx4\use=
r\hca;..\..\..\..\inc\complib

 RCOPTIONS=3D/I..\..\win\include

Index: D:/Windows/MLNX_VPI/tools/perftests/user/write_bw/write_bw.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- D:/Windows/MLNX_VPI/tools/perftests/user/write_bw/write_bw.c           =
   (revision 6545)
+++ D:/Windows/MLNX_VPI/tools/perftests/user/write_bw/write_bw.c           =
(revision 6546)
@@ -34,12 +34,12 @@
  * $Id$
  */

+
 #include "getopt.h"
 #include "perf_defs.h"
 #include "get_clock.h"
+#include "l2w.h"

-
-
 struct user_parameters {
                const char              *servername;
                int connection_type;
@@ -66,7 +66,7 @@
                UNUSED_PARAM( cq_context);
                return ;
 }
-static struct pingpong_context *pp_init_ctx(unsigned size, int port, struc=
t user_parameters *user_parm)
+static struct pingpong_context *pp_init_ctx(unsigned size, int port, struc=
t user_parameters *user_parm, char* ib_devguid)
 {

                struct pingpong_context              *ctx;
@@ -74,6 +74,7 @@
                size_t                                                     =
               guid_count;
                ib_net64_t                                                 =
         *ca_guid_array;
                int                                                        =
                                   counter;
+             int                                                          =
                 guid_index =3D 0;

                ctx =3D malloc(sizeof *ctx);
                if (!ctx){
@@ -159,7 +160,28 @@
                 * Open only the first HCA
                 */
                /* Open the CA */
-              ib_status =3D ib_open_ca(ctx->al ,ca_guid_array[0] ,NULL,
+             if (ib_devguid)
+             {
+                             unsigned int i =3D 0;
+                             guid_index =3D -1;
+                             for (i =3D 0; i < guid_count; i++)
+                             {
+                                             char curr_dev[20];
+                                             sprintf(curr_dev, "0x%016I64x=
", ntohll(ca_guid_array[i]));
+                                             if (!_stricmp(ib_devguid, cur=
r_dev))
+                                             {
+                                                             guid_index =
=3D i;
+                                                             break;
+                                             }
+                             }
+                             if (guid_index =3D=3D -1)
+                             {
+                                             fprintf(stderr,"device with g=
uid %s was not found\n", ib_devguid);
+                                             return NULL;
+                             }
+             }
+
+             ib_status =3D ib_open_ca(ctx->al ,ca_guid_array[guid_index] ,=
NULL,
                                NULL,    //ca_context
                                &ctx->ca);

@@ -476,6 +498,7 @@
                printf("\n");
                printf("Options:\n");
                printf("  -p, --port=3D<port>         listen on/connect to =
port <port> (default 18515)\n");
+             printf("  -d, --ib-dev=3D<dev>        use IB device <device g=
uid> (default first device found)\n");
                printf("  -i, --ib-port=3D<port>      use port <port> of IB=
 device (default 1)\n");
                printf("  -c, --connection=3D<RC/UC>  connection type RC/UC=
 (default RC)\n");
                printf("  -m, --mtu=3D<mtu>           mtu size (default 102=
4)\n");
@@ -650,7 +673,7 @@
                struct pingpong_dest     *my_dest;
                struct pingpong_dest     *rem_dest;
                struct user_parameters  user_param;
-              char                                                       *=
ib_devname =3D NULL;
+             char                                                       *i=
b_devguid =3D NULL;
                int                                                        =
   port =3D 18515;
                int                                                        =
   ib_port =3D 1;
                unsigned                                             size =
=3D 65536;
@@ -661,6 +684,9 @@
                int                                                        =
   duplex =3D 0;


+             SYSTEM_INFO si;
+             GetSystemInfo(&si);
+
                /* init default values to user's parameters */
                memset(&user_param, 0, sizeof(struct user_parameters));
                user_param.mtu =3D 0;
@@ -705,7 +731,7 @@
                                                break;

                                case 'd':
-                                              ib_devname =3D _strdup(optar=
g);
+                                             ib_devguid =3D _strdup(optarg=
);
                                                break;
                                case 'c':
                                                if (strcmp("UC",optarg)=3D=
=3D0)
@@ -814,13 +840,9 @@
                }
                srand(GetCurrentProcessId() * GetTickCount());

-              //TODO: get pagesize from sysinfo
-              page_size =3D 4096;
-
-              //TODO  get the device names
-
-
-              ctx =3D pp_init_ctx(size, ib_port, &user_param);
+             page_size =3D si.dwPageSize;
+
+             ctx =3D pp_init_ctx(size, ib_port, &user_param, ib_devguid);
                if (!ctx)
                                return 8;
                sockfd =3D pp_open_port(ctx, user_param.servername, ib_port=
, port,&my_dest,&rem_dest,&user_param);
Index: D:/Windows/MLNX_VPI/tools/perftests/user/send_lat/SOURCES
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- D:/Windows/MLNX_VPI/tools/perftests/user/send_lat/SOURCES    (revision =
6545)
+++ D:/Windows/MLNX_VPI/tools/perftests/user/send_lat/SOURCES (revision 654=
6)
@@ -11,7 +11,7 @@
                ..\perf_utils.c \
                send_lat.c

-INCLUDES=3D..;..\..\..\..\inc;..\..\..\..\inc\user
+INCLUDES=3D..;..\..\..\..\inc;..\..\..\..\inc\user;..\..\..\..\hw\mlx4\use=
r\hca;..\..\..\..\inc\complib

 RCOPTIONS=3D/I..\..\win\include

Index: D:/Windows/MLNX_VPI/tools/perftests/user/send_lat/send_lat.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- D:/Windows/MLNX_VPI/tools/perftests/user/send_lat/send_lat.c  (revision=
 6545)
+++ D:/Windows/MLNX_VPI/tools/perftests/user/send_lat/send_lat.c           =
    (revision 6546)
@@ -38,6 +38,7 @@
 #include "getopt.h"
 #include "get_clock.h"
 #include "perf_defs.h"
+#include "l2w.h"



@@ -67,12 +68,13 @@
 }


-static struct pingpong_context *pp_init_ctx(unsigned int size,int port,str=
uct user_parameters *user_parm) {
+static struct pingpong_context *pp_init_ctx(unsigned int size,int port,str=
uct user_parameters *user_parm, char* ib_devguid) {

                struct pingpong_context              *ctx;
                ib_api_status_t                                            =
    ib_status =3D IB_SUCCESS;
                size_t                                                     =
               guid_count;
                ib_net64_t                                                 =
         *ca_guid_array;
+             int                                                          =
                 guid_index =3D 0;



@@ -156,7 +158,29 @@
                 * Open only the first HCA
                 */
                /* Open the CA */
-              ib_status =3D ib_open_ca(ctx->al ,ca_guid_array[0] ,NULL,
+             if (ib_devguid)
+             {
+                             unsigned int i =3D 0;
+                             guid_index =3D -1;
+                             for (i =3D 0; i < guid_count; i++)
+                             {
+                                             char curr_dev[20];
+                                             sprintf(curr_dev, "0x%016I64x=
", ntohll(ca_guid_array[i]));
+                                             if (!_stricmp(ib_devguid, cur=
r_dev))
+                                             {
+                                                             guid_index =
=3D i;
+                                                             break;
+                                             }
+                             }
+                             if (guid_index =3D=3D -1)
+                             {
+                                             fprintf(stderr,"device with g=
uid %s was not found\n", ib_devguid);
+                                             return NULL;
+                             }
+             }
+
+
+             ib_status =3D ib_open_ca(ctx->al ,ca_guid_array[guid_index] ,=
NULL,
                                NULL,    //ca_context
                                &ctx->ca);

@@ -536,6 +560,7 @@
                printf("\n");
                printf("Options:\n");
                printf("  -p, --port=3D<port>            listen on/connect =
to port <port> (default 18515)\n");
+             printf("  -d, --ib-dev=3D<dev>           use IB device <devic=
e guid> (default first device found)\n");
                printf("  -c, --connection=3D<RC/UC>     connection type RC=
/UC (default RC)\n");
                printf("  -m, --mtu=3D<mtu>              mtu size (default =
2048)\n");
                printf("  -i, --ib-port=3D<port>         use port <port> of=
 IB device (default 1)\n");
@@ -793,7 +818,7 @@
                struct pingpong_dest     *my_dest;
                struct pingpong_dest     *rem_dest;
                struct user_parameters  user_param;
-              char                                                       *=
ib_devname =3D NULL;
+             char                                                       *i=
b_devguid =3D NULL;
                int                                                        =
   port =3D 18515;
                int                                                        =
   ib_port =3D 1;
                unsigned                                             size =
=3D 2;
@@ -806,6 +831,9 @@

                struct report_options    report =3D {0};

+             SYSTEM_INFO si;
+             GetSystemInfo(&si);
+
                /* init default values to user's parameters */
                memset(&user_param, 0, sizeof(struct user_parameters));
                user_param.mtu =3D 0;
@@ -867,7 +895,7 @@
                                                return 0;
                                                break;
                                case 'd':
-                                              ib_devname =3D _strdup(optar=
g);
+                                             ib_devguid =3D _strdup(optarg=
);
                                                break;

                                case 'i':
@@ -967,12 +995,9 @@

                srand(GetCurrentProcessId() * GetTickCount());

-              //TODO: get pagesize from sysinfo
-              page_size =3D 4096;
-
-              //TODO  get the device names
+             page_size =3D si.dwPageSize;

-              ctx =3D pp_init_ctx( size, ib_port,&user_param);
+             ctx =3D pp_init_ctx( size, ib_port,&user_param, ib_devguid);
                if (!ctx)
                                return 8;

Index: D:/Windows/MLNX_VPI/tools/perftests/user/write_lat/SOURCES
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- D:/Windows/MLNX_VPI/tools/perftests/user/write_lat/SOURCES    (revision=
 6545)
+++ D:/Windows/MLNX_VPI/tools/perftests/user/write_lat/SOURCES (revision 65=
46)
@@ -11,7 +11,7 @@
                ..\perf_utils.c \
                write_lat.c

-INCLUDES=3D..;..\..\..\..\inc;..\..\..\..\inc\user
+INCLUDES=3D..;..\..\..\..\inc;..\..\..\..\inc\user;..\..\..\..\hw\mlx4\use=
r\hca;..\..\..\..\inc\complib

 RCOPTIONS=3D/I..\..\win\include

Index: D:/Windows/MLNX_VPI/tools/perftests/user/write_lat/write_lat.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- D:/Windows/MLNX_VPI/tools/perftests/user/write_lat/write_lat.c (revisio=
n 6545)
+++ D:/Windows/MLNX_VPI/tools/perftests/user/write_lat/write_lat.c         =
     (revision 6546)
@@ -38,6 +38,7 @@
 #include "getopt.h"
 #include "perf_defs.h"
 #include "get_clock.h"
+#include "l2w.h"



@@ -68,7 +69,7 @@
 }


-static struct pingpong_context *pp_init_ctx(unsigned size, int port, struc=
t user_parameters *user_parm)
+static struct pingpong_context *pp_init_ctx(unsigned size, int port, struc=
t user_parameters *user_parm, char* ib_devguid)
 {


@@ -76,6 +77,7 @@
                ib_api_status_t                                            =
    ib_status =3D IB_SUCCESS;
                size_t                                                     =
               guid_count;
                ib_net64_t                                                 =
         *ca_guid_array;
+             int                                                          =
                                 guid_index =3D 0;

                ctx =3D malloc(sizeof *ctx);
                if (!ctx){
@@ -150,7 +152,28 @@
                 * Open only the first HCA
                 */
                /* Open the CA */
-              ib_status =3D ib_open_ca(ctx->al ,ca_guid_array[0] ,NULL,
+             if (ib_devguid)
+             {
+                             unsigned int i =3D 0;
+                             guid_index =3D -1;
+                             for (i =3D 0; i < guid_count; i++)
+                             {
+                                             char curr_dev[20];
+                                             sprintf(curr_dev, "0x%016I64x=
", ntohll(ca_guid_array[i]));
+                                             if (!_stricmp(ib_devguid, cur=
r_dev))
+                                             {
+                                                             guid_index =
=3D i;
+                                                             break;
+                                             }
+                             }
+                             if (guid_index =3D=3D -1)
+                             {
+                                             fprintf(stderr,"device with g=
uid %s was not found\n", ib_devguid);
+                                             return NULL;
+                             }
+             }
+
+             ib_status =3D ib_open_ca(ctx->al ,ca_guid_array[guid_index] ,=
NULL,
                                NULL,    //ca_context
                                &ctx->ca);

@@ -465,6 +488,7 @@
                printf("\n");
                printf("Options:\n");
                printf("  -p, --port=3D<port>            listen on/connect =
to port <port> (default 18515)\n");
+             printf("  -d, --ib-dev=3D<dev>        use IB device <device g=
uid> (default first device found)\n");
                printf("  -c, --connection=3D<RC/UC>     connection type RC=
/UC (default RC)\n");
                printf("  -m, --mtu=3D<mtu>              mtu size (default =
1024)\n");
                printf("  -i, --ib-port=3D<port>         use port <port> of=
 IB device (default 1)\n");
@@ -647,7 +671,7 @@
                struct pingpong_dest     *my_dest;
                struct pingpong_dest     *rem_dest;
                struct user_parameters  user_param;
-              char                                                       *=
ib_devname =3D NULL;
+             char                                                       *i=
b_devguid =3D NULL;
                int                                                        =
   port =3D 18515;
                int                                                        =
   ib_port =3D 1;
                unsigned                                             size =
=3D 2;
@@ -657,6 +681,8 @@
                int                                                        =
   iResult;
                struct report_options    report =3D {0};

+             SYSTEM_INFO si;
+             GetSystemInfo(&si);

                /* init default values to user's parameters */
                memset(&user_param, 0, sizeof(struct user_parameters));
@@ -715,7 +741,7 @@
                                                return 0;
                                                break;
                                case 'd':
-                                              ib_devname =3D _strdup(optar=
g);
+                                             ib_devguid =3D _strdup(optarg=
);
                                                break;

                                case 'i':
@@ -811,13 +837,9 @@
                }
                srand(GetCurrentProcessId() * GetTickCount());

-              //TODO: get pagesize from sysinfo
-              page_size =3D 4096;
+             page_size =3D si.dwPageSize;

-              //TODO  get the device names
-
-
-              ctx =3D pp_init_ctx( size, ib_port,&user_param);
+             ctx =3D pp_init_ctx( size, ib_port,&user_param, ib_devguid);
                if (!ctx)
                                return 8;
                sockfd =3D pp_open_port(ctx, user_param.servername, ib_port=
, port,&my_dest,&rem_dest,&user_param);
@@ -846,4 +868,4 @@
                printf("---------------------------------------------------=
---------------\n");
                free(tstamp);
                return 0;
-}
+}
\ No newline at end of file
Index: D:/Windows/MLNX_VPI/tools/perftests/user/read_bw/SOURCES
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- D:/Windows/MLNX_VPI/tools/perftests/user/read_bw/SOURCES    (revision 6=
545)
+++ D:/Windows/MLNX_VPI/tools/perftests/user/read_bw/SOURCES (revision 6546=
)
@@ -11,7 +11,7 @@
                ..\perf_utils.c \
                read_bw.c

-INCLUDES=3D..;..\..\..\..\inc;..\..\..\..\inc\user
+INCLUDES=3D..;..\..\..\..\inc;..\..\..\..\inc\user;..\..\..\..\hw\mlx4\use=
r\hca;..\..\..\..\inc\complib

 RCOPTIONS=3D/I..\..\win\include

Index: D:/Windows/MLNX_VPI/tools/perftests/user/read_bw/read_bw.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- D:/Windows/MLNX_VPI/tools/perftests/user/read_bw/read_bw.c (revision 65=
45)
+++ D:/Windows/MLNX_VPI/tools/perftests/user/read_bw/read_bw.c             =
 (revision 6546)
@@ -37,6 +37,7 @@
 #include "getopt.h"
 #include "perf_defs.h"
 #include "get_clock.h"
+#include "l2w.h"

 struct user_parameters {
                const char              *servername;
@@ -64,13 +65,14 @@
                return ;
 }

-static struct pingpong_context *pp_init_ctx(unsigned size,int port, struct=
 user_parameters *user_parm)
+static struct pingpong_context *pp_init_ctx(unsigned size,int port, struct=
 user_parameters *user_parm, char* ib_devguid)
 {

                struct pingpong_context              *ctx;
                ib_api_status_t                                            =
    ib_status =3D IB_SUCCESS;
                size_t                                                     =
               guid_count;
                ib_net64_t                                                 =
         *ca_guid_array;
+             int                                                          =
                 guid_index =3D 0;


                ctx =3D malloc(sizeof *ctx);
@@ -145,7 +147,28 @@
                 * Open only the first HCA
                 */
                /* Open the CA */
-              ib_status =3D ib_open_ca(ctx->al ,ca_guid_array[0] ,NULL,
+             if (ib_devguid)
+             {
+                             unsigned int i =3D 0;
+                             guid_index =3D -1;
+                             for (i =3D 0; i < guid_count; i++)
+                             {
+                                             char curr_dev[20];
+                                             sprintf(curr_dev, "0x%016I64x=
", ntohll(ca_guid_array[i]));
+                                             if (!_stricmp(ib_devguid, cur=
r_dev))
+                                             {
+                                                             guid_index =
=3D i;
+                                                             break;
+                                             }
+                             }
+                             if (guid_index =3D=3D -1)
+                             {
+                                             fprintf(stderr,"device with g=
uid %s was not found\n", ib_devguid);
+                                             return NULL;
+                             }
+             }
+
+             ib_status =3D ib_open_ca(ctx->al ,ca_guid_array[guid_index] ,=
NULL,
                                NULL,    //ca_context
                                &ctx->ca);

@@ -445,6 +468,7 @@
                printf("\n");
                printf("Options:\n");
                printf("  -p, --port=3D<port>      listen on/connect to por=
t <port> (default 18515)\n");
+             printf("  -d, --ib-dev=3D<dev>        use IB device <device g=
uid> (default first device found)\n");
                printf("  -i, --ib-port=3D<port>   use port <port> of IB de=
vice (default 1)\n");
                printf("  -m, --mtu=3D<mtu>        mtu size (default 1024)\=
n");
                printf("  -o, --outs=3D<num>       num of outstanding read/=
atom(default 4)\n");
@@ -582,7 +606,7 @@
                struct pingpong_dest     *my_dest;
                struct pingpong_dest     *rem_dest;
                struct user_parameters  user_param;
-              char                                                       *=
ib_devname =3D NULL;
+             char                                                       *i=
b_devguid =3D NULL;
                int                                                        =
   port =3D 18515;
                int                                                        =
   ib_port =3D 1;
                unsigned                                             size =
=3D 65536;
@@ -592,6 +616,9 @@
                int                                                        =
   i =3D 0;
                int                                                        =
   duplex =3D 0;

+             SYSTEM_INFO si;
+             GetSystemInfo(&si);
+
                /* init default values to user's parameters */
                memset(&user_param, 0, sizeof(struct user_parameters));
                user_param.mtu =3D 0; /* signal choose default by device */
@@ -632,7 +659,7 @@
                                                break;

                                case 'd':
-                                              ib_devname =3D _strdup(optar=
g);
+                                             ib_devguid =3D _strdup(optarg=
);
                                                break;
                                case 'm':
                                                user_param.mtu =3D strtol(o=
ptarg, NULL, 0);
@@ -717,13 +744,9 @@

                srand(GetCurrentProcessId() * GetTickCount());

-              //TODO: get pagesize from sysinfo
-              page_size =3D 4096;
+             page_size =3D si.dwPageSize;

-              //TODO:get the device names
-
-
-              ctx =3D pp_init_ctx(size,ib_port, &user_param);
+             ctx =3D pp_init_ctx(size,ib_port, &user_param, ib_devguid);
                if (!ctx)
                                return 8;

Index: D:/Windows/MLNX_VPI/tools/perftests/user/read_lat/SOURCES
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- D:/Windows/MLNX_VPI/tools/perftests/user/read_lat/SOURCES     (revision=
 6545)
+++ D:/Windows/MLNX_VPI/tools/perftests/user/read_lat/SOURCES  (revision 65=
46)
@@ -11,7 +11,7 @@
                ..\perf_utils.c \
                read_lat.c

-INCLUDES=3D..;..\..\..\..\inc;..\..\..\..\inc\user
+INCLUDES=3D..;..\..\..\..\inc;..\..\..\..\inc\user;..\..\..\..\hw\mlx4\use=
r\hca;..\..\..\..\inc\complib

 RCOPTIONS=3D/I..\..\win\include

Index: D:/Windows/MLNX_VPI/tools/perftests/user/read_lat/read_lat.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- D:/Windows/MLNX_VPI/tools/perftests/user/read_lat/read_lat.c    (revisi=
on 6545)
+++ D:/Windows/MLNX_VPI/tools/perftests/user/read_lat/read_lat.c (revision =
6546)
@@ -38,6 +38,7 @@
 #include "getopt.h"
 #include "perf_defs.h"
 #include "get_clock.h"
+#include "l2w.h"



@@ -68,7 +69,7 @@
                return ;
 }

-static struct pingpong_context *pp_init_ctx(unsigned size,int port, struct=
 user_parameters *user_parm)
+static struct pingpong_context *pp_init_ctx(unsigned size,int port, struct=
 user_parameters *user_parm, char* ib_devguid)
 {


@@ -76,6 +77,7 @@
                ib_api_status_t                                            =
    ib_status =3D IB_SUCCESS;
                size_t                                                     =
               guid_count;
                ib_net64_t                                                 =
         *ca_guid_array;
+             int                                                          =
                                 guid_index =3D 0;


                ctx =3D malloc(sizeof *ctx);
@@ -149,7 +151,28 @@
                 * Open only the first HCA
                 */
                /* Open the CA */
-              ib_status =3D ib_open_ca(ctx->al ,ca_guid_array[0] ,NULL,
+             if (ib_devguid)
+             {
+                             unsigned int i =3D 0;
+                             guid_index =3D -1;
+                             for (i =3D 0; i < guid_count; i++)
+                             {
+                                             char curr_dev[20];
+                                             sprintf(curr_dev, "0x%016I64x=
", ntohll(ca_guid_array[i]));
+                                             if (!_stricmp(ib_devguid, cur=
r_dev))
+                                             {
+                                                             guid_index =
=3D i;
+                                                             break;
+                                             }
+                             }
+                             if (guid_index =3D=3D -1)
+                             {
+                                             fprintf(stderr,"device with g=
uid %s was not found\n", ib_devguid);
+                                             return NULL;
+                             }
+             }
+
+             ib_status =3D ib_open_ca(ctx->al ,ca_guid_array[guid_index] ,=
NULL,
                                NULL,    //ca_context
                                &ctx->ca);

@@ -456,6 +479,7 @@
                printf("\n");
                printf("Options:\n");
                printf("  -p, --port=3D<port>            listen on/connect =
to port <port> (default 18515)\n");
+             printf("  -d, --ib-dev=3D<dev>           use IB device <devic=
e guid> (default first device found)\n");
                printf("  -m, --mtu=3D<mtu>              mtu size (default =
256)\n");
                printf("  -i, --ib-port=3D<port>         use port <port> of=
 IB device (default 1)\n");
                printf("  -s, --size=3D<size>            size of message to=
 exchange (default 1)\n");
@@ -598,7 +622,7 @@
                struct pingpong_dest     *my_dest;
                struct pingpong_dest     *rem_dest;
                struct user_parameters  user_param;
-              char                                                       *=
ib_devname =3D NULL;
+             char                                                       *i=
b_devguid =3D NULL;
                int                                                        =
   port =3D 18515;
                int                                                        =
   ib_port =3D 1;
                unsigned                                             tmp_si=
ze,size =3D 2;
@@ -608,6 +632,8 @@
                int                                                        =
   i =3D 0;
                struct report_options    report =3D {0};

+             SYSTEM_INFO si;
+             GetSystemInfo(&si);

                /* init default values to user's parameters */
                memset(&user_param, 0, sizeof(struct user_parameters));
@@ -665,7 +691,7 @@
                                                return 0;
                                                break;
                                case 'd':
-                                              ib_devname =3D _strdup(optar=
g);
+                                             ib_devguid =3D _strdup(optarg=
);
                                                break;

                                case 'i':
@@ -755,13 +781,9 @@

                srand(GetCurrentProcessId() * GetTickCount());

-              //TODO: get pagesize from sysinfo
-              page_size =3D 4096;
+             page_size =3D si.dwPageSize;

-              //TODO:get the device names
-
-
-              ctx =3D pp_init_ctx(size,ib_port, &user_param);
+             ctx =3D pp_init_ctx(size,ib_port, &user_param, ib_devguid);
                if (!ctx)
                                return 8;


--_000_E113D394D7C5DB4F8FF691FA7EE9DB443BF12865D0MTLMAILmtlcom_
Content-Type: text/html; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

<html xmlns:v=3D"urn:schemas-microsoft-com:vml" xmlns:o=3D"urn:schemas-micr=
osoft-com:office:office" xmlns:w=3D"urn:schemas-microsoft-com:office:word" =
xmlns:m=3D"http://schemas.microsoft.com/office/2004/12/omml" xmlns=3D"http:=
//www.w3.org/TR/REC-html40">

<head>
<META HTTP-EQUIV=3D"Content-Type" CONTENT=3D"text/html; charset=3Dus-ascii"=
>
<meta name=3DGenerator content=3D"Microsoft Word 12 (filtered medium)">
<style>
<!--
 /* Font Definitions */
 @font-face
	{font-family:"Cambria Math";
	panose-1:2 4 5 3 5 4 6 3 2 4;}
@font-face
	{font-family:Calibri;
	panose-1:2 15 5 2 2 2 4 3 2 4;}
 /* Style Definitions */
 p.MsoNormal, li.MsoNormal, div.MsoNormal
	{margin:0in;
	margin-bottom:.0001pt;
	font-size:11.0pt;
	font-family:"Calibri","sans-serif";}
a:link, span.MsoHyperlink
	{mso-style-priority:99;
	color:blue;
	text-decoration:underline;}
a:visited, span.MsoHyperlinkFollowed
	{mso-style-priority:99;
	color:purple;
	text-decoration:underline;}
span.EmailStyle17
	{mso-style-type:personal-compose;
	font-family:"Calibri","sans-serif";
	color:windowtext;}
.MsoChpDefault
	{mso-style-type:export-only;}
@page WordSection1
	{size:8.5in 11.0in;
	margin:1.0in 1.0in 1.0in 1.0in;}
div.WordSection1
	{page:WordSection1;}
-->
</style>
<!--[if gte mso 9]><xml>
 <o:shapedefaults v:ext=3D"edit" spidmax=3D"1026" />
</xml><![endif]--><!--[if gte mso 9]><xml>
 <o:shapelayout v:ext=3D"edit">
  <o:idmap v:ext=3D"edit" data=3D"1" />
 </o:shapelayout></xml><![endif]-->
</head>

<body lang=3DEN-US link=3Dblue vlink=3Dpurple>

<div class=3DWordSection1>

<p class=3DMsoNormal>Signed-off-by: Irena Gannon (<a
href=3D"mailto:irena@mellanox.co.il">irena@mellanox.co.il</a>) <o:p></o:p><=
/p>

<p class=3DMsoNormal><o:p>&nbsp;</o:p></p>

<p class=3DMsoNormal>This patch adds a -d &lt;guid&gt; option to the tests =
to
enable choosing a device to run on.<o:p></o:p></p>

<p class=3DMsoNormal><o:p>&nbsp;</o:p></p>

<p class=3DMsoNormal>Index:
D:/Windows/MLNX_VPI/tools/perftests/user/send_bw/send_bw.c<o:p></o:p></p>

<p class=3DMsoNormal>=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D<o:=
p></o:p></p>

<p class=3DMsoNormal>---
D:/Windows/MLNX_VPI/tools/perftests/user/send_bw/send_bw.c&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; (=
revision
6545)<o:p></o:p></p>

<p class=3DMsoNormal>+++
D:/Windows/MLNX_VPI/tools/perftests/user/send_bw/send_bw.c&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; (revision
6546)<o:p></o:p></p>

<p class=3DMsoNormal>@@ -38,6 +38,7 @@<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;#include &quot;get_clock.h&quot;<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;#include &quot;perf_defs.h&quot;<o:p></o:p></p>

<p class=3DMsoNormal>+#include &quot;l2w.h&quot;<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;#define SIGNAL 1<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;#define MAX_INLINE 400<o:p></o:p></p>

<p class=3DMsoNormal>@@ -73,13 +74,14 @@<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;static struct pingpong_context *pp_init_ctx(unsi=
gned
size,int port, <o:p></o:p></p>

<p class=3DMsoNormal>-&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; struct
user_parameters *user_parm)<o:p></o:p></p>

<p class=3DMsoNormal>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp; struct
user_parameters *user_parm, char* ib_devguid)<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;{<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; struct pingpong_context&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; *ctx;<o:p><=
/o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ib_api_status_t &nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ib_status
=3D IB_SUCCESS;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp; <o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; size_t &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; guid_coun=
t;<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ib_net64_t&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp; *ca_guid_array;<o:p></o:p></p>

<p class=3DMsoNormal>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp; int &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp; guid_index
=3D 0;<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <o:p></o:p></p>

<p class=3DMsoNormal>@@ -158,7 +160,28 @@<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;* Open only the first HCA<o:p></=
o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;*/<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; /* Open the CA */<o:p></o:p></p>

<p class=3DMsoNormal>-&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp; ib_status =3D ib_open_ca(ctx-&gt;al
,ca_guid_array[0] ,NULL,<o:p></o:p></p>

<p class=3DMsoNormal>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp; if (ib_devguid) <o:p></o:p></p>

<p class=3DMsoNormal>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp; {<o:p></o:p></p>

<p class=3DMsoNormal>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; unsigned int i =3D 0;<o:p></o:p></=
p>

<p class=3DMsoNormal>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; guid_index =3D -1;<o:p></o:p></p>

<p class=3DMsoNormal>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; for (i =3D 0; i &lt; guid_count;
i++)<o:p></o:p></p>

<p class=3DMsoNormal>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; {<o:p></o:p></p>

<p class=3DMsoNormal>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; char
curr_dev[20];<o:p></o:p></p>

<p class=3DMsoNormal>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; sprintf(curr_=
dev,
&quot;0x%016I64x&quot;, ntohll(ca_guid_array[i]));<o:p></o:p></p>

<p class=3DMsoNormal>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; if
(!_stricmp(ib_devguid, curr_dev))<o:p></o:p></p>

<p class=3DMsoNormal>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; {<o:p></o:p><=
/p>

<p class=3DMsoNormal>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp; guid_index
=3D i;<o:p></o:p></p>

<p class=3DMsoNormal>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp; break;<o:p></o:p></p>

<p class=3DMsoNormal>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; }<o:p></o:p><=
/p>

<p class=3DMsoNormal>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; }<o:p></o:p></p>

<p class=3DMsoNormal>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; if (guid_index =3D=3D -1)<o:p></o:=
p></p>

<p class=3DMsoNormal>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; {<o:p></o:p></p>

<p class=3DMsoNormal>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; fprintf(stder=
r,&quot;device
with guid %s was not found\n&quot;, ib_devguid);<o:p></o:p></p>

<p class=3DMsoNormal>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; return NULL;<=
o:p></o:p></p>

<p class=3DMsoNormal>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; }<o:p></o:p></p>

<p class=3DMsoNormal>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp; }<o:p></o:p></p>

<p class=3DMsoNormal>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp; <o:p></o:p></p>

<p class=3DMsoNormal>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp; ib_status =3D ib_open_ca(ctx-&gt;al
,ca_guid_array[guid_index] ,NULL,<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; NULL,&nbsp;&nbsp;=
&nbsp; //ca_context<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &amp;ctx-&gt;ca);=
<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;<o:p></o:p></p>

<p class=3DMsoNormal>@@ -549,6 +572,7 @@<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; printf(&quot;\n&quot;);<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; printf(&quot;Options:\n&quot;);<o:p></=
o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; printf(&quot;&nbsp; -p,
--port=3D&lt;port&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; liste=
n on/connect to port &lt;port&gt; (default
18515)\n&quot;);<o:p></o:p></p>

<p class=3DMsoNormal>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp; printf(&quot;&nbsp; -d, --ib-dev=3D&lt;dev&gt;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
use IB device &lt;device guid&gt; (default first device found)\n&quot;);<o:=
p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; printf(&quot;&nbsp; -i,
--ib-port=3D&lt;port&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; use port &lt;port&gt=
; of IB device (default
1)\n&quot;);<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; printf(&quot;&nbsp; -c,
--connection=3D&lt;RC/UC&gt;&nbsp; connection type RC/UC/UD (default RC)\n&=
quot;);<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; printf(&quot;&nbsp; -m,
--mtu=3D&lt;mtu&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp; mtu size (default 1024)\n&quot;);<o:p></o:p></p>

<p class=3DMsoNormal>@@ -943,7 +967,7 @@<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; struct pingpong_dest&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp; *my_dest;<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; struct pingpong_dest&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp; *rem_dest;<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; struct user_parameters&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp; user_param;<o:p></o:p></p>

<p class=3DMsoNormal>-&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp; char&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; *ib_devname
=3D NULL;<o:p></o:p></p>

<p class=3DMsoNormal>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp; char&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; *ib_devguid
=3D NULL;<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; int&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp; port
=3D 18515;<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; int&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp; ib_port
=3D 1;<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; unsigned&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp; size
=3D 65536;<o:p></o:p></p>

<p class=3DMsoNormal>@@ -953,6 +977,8 @@<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; WSADATA&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp; wsaData;<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; int&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp; iResult;<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;<o:p></o:p></p>

<p class=3DMsoNormal>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp; SYSTEM_INFO si;<o:p></o:p></p>

<p class=3DMsoNormal>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp; GetSystemInfo(&amp;si);<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; /* init default values to user's param=
eters
*/<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; memset(&amp;user_param, 0, sizeof(stru=
ct
user_parameters));<o:p></o:p></p>

<p class=3DMsoNormal>@@ -998,7 +1024,7 @@<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp; ++user_param.use_event;<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp; break;<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; case 'd':<o:p></o=
:p></p>

<p class=3DMsoNormal>-&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ib_devn=
ame =3D
_strdup(optarg);<o:p></o:p></p>

<p class=3DMsoNormal>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ib_devguid =
=3D
_strdup(optarg);<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp; break;<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; case 'c':<o:p></o=
:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp; if
(strcmp(&quot;UC&quot;,optarg)=3D=3D0)<o:p></o:p></p>

<p class=3DMsoNormal>@@ -1100,14 +1126,11 @@<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; srand(GetCurrentProcessId() *
GetTickCount());<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;<o:p></o:p></p>

<p class=3DMsoNormal>-&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp; //TODO: get pagesize from sysinfo<o:p></o:p></p>

<p class=3DMsoNormal>-&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp; page_size =3D 4096;<o:p></o:p></p>

<p class=3DMsoNormal>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp; page_size =3D si.dwPageSize;<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;<o:p></o:p></p>

<p class=3DMsoNormal>-&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp; //TODO:get the device names<o:p></o:p></p>

<p class=3DMsoNormal>-&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp; <o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; // init the context<o:p></o:p></p>

<p class=3DMsoNormal>-&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp; ctx =3D pp_init_ctx(size, ib_port,
&amp;user_param);<o:p></o:p></p>

<p class=3DMsoNormal>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp; ctx =3D pp_init_ctx(size, ib_port,
&amp;user_param, ib_devguid);<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; if (!ctx)<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; return 1;<o:p></o=
:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <o:p></o:p></p>

<p class=3DMsoNormal>Index:
D:/Windows/MLNX_VPI/tools/perftests/user/send_bw/SOURCES<o:p></o:p></p>

<p class=3DMsoNormal>=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D<o:=
p></o:p></p>

<p class=3DMsoNormal>--- D:/Windows/MLNX_VPI/tools/perftests/user/send_bw/S=
OURCES&nbsp;&nbsp; (revision
6545)<o:p></o:p></p>

<p class=3DMsoNormal>+++ D:/Windows/MLNX_VPI/tools/perftests/user/send_bw/S=
OURCES&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp; (revision
6546)<o:p></o:p></p>

<p class=3DMsoNormal>@@ -11,7 +11,7 @@<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ..\perf_utils.c \<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; send_bw.c <o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;<o:p></o:p></p>

<p class=3DMsoNormal>-INCLUDES=3D..;..\..\..\..\inc;..\..\..\..\inc\user<o:=
p></o:p></p>

<p class=3DMsoNormal>+INCLUDES=3D..;..\..\..\..\inc;..\..\..\..\inc\user;..=
\..\..\..\hw\mlx4\user\hca;..\..\..\..\inc\complib<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;RCOPTIONS=3D/I..\..\win\include<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;<o:p></o:p></p>

<p class=3DMsoNormal>Index:
D:/Windows/MLNX_VPI/tools/perftests/user/write_bw/SOURCES<o:p></o:p></p>

<p class=3DMsoNormal>=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D<o:=
p></o:p></p>

<p class=3DMsoNormal>---
D:/Windows/MLNX_VPI/tools/perftests/user/write_bw/SOURCES&nbsp; (revision 6=
545)<o:p></o:p></p>

<p class=3DMsoNormal>+++
D:/Windows/MLNX_VPI/tools/perftests/user/write_bw/SOURCES&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; (revisio=
n
6546)<o:p></o:p></p>

<p class=3DMsoNormal>@@ -11,7 +11,7 @@<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ..\perf_utils.c \<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; write_bw.c <o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;<o:p></o:p></p>

<p class=3DMsoNormal>-INCLUDES=3D..;..\..\..\..\inc;..\..\..\..\inc\user<o:=
p></o:p></p>

<p class=3DMsoNormal>+INCLUDES=3D..;..\..\..\..\inc;..\..\..\..\inc\user;..=
\..\..\..\hw\mlx4\user\hca;..\..\..\..\inc\complib<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;RCOPTIONS=3D/I..\..\win\include<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;<o:p></o:p></p>

<p class=3DMsoNormal>Index:
D:/Windows/MLNX_VPI/tools/perftests/user/write_bw/write_bw.c<o:p></o:p></p>

<p class=3DMsoNormal>=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D<o:=
p></o:p></p>

<p class=3DMsoNormal>---
D:/Windows/MLNX_VPI/tools/perftests/user/write_bw/write_bw.c&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; (revision
6545)<o:p></o:p></p>

<p class=3DMsoNormal>+++
D:/Windows/MLNX_VPI/tools/perftests/user/write_bw/write_bw.c&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; (revision
6546)<o:p></o:p></p>

<p class=3DMsoNormal>@@ -34,12 +34,12 @@<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp; * $Id$<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp; */<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp; <o:p></o:p></p>

<p class=3DMsoNormal>+<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;#include &quot;getopt.h&quot;<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;#include &quot;perf_defs.h&quot;<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;#include &quot;get_clock.h&quot;<o:p></o:p></p>

<p class=3DMsoNormal>+#include &quot;l2w.h&quot;<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;<o:p></o:p></p>

<p class=3DMsoNormal>-<o:p></o:p></p>

<p class=3DMsoNormal>-<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;struct user_parameters {<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; const char&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; *servername;<o:p></o:p><=
/p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; int connection_type;<o:p></o:p></p>

<p class=3DMsoNormal>@@ -66,7 +66,7 @@<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; UNUSED_PARAM( cq_context);<o:p></o:p><=
/p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; return ;<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;}<o:p></o:p></p>

<p class=3DMsoNormal>-static struct pingpong_context *pp_init_ctx(unsigned =
size,
int port, struct user_parameters *user_parm)<o:p></o:p></p>

<p class=3DMsoNormal>+static struct pingpong_context *pp_init_ctx(unsigned =
size,
int port, struct user_parameters *user_parm, char* ib_devguid)<o:p></o:p></=
p>

<p class=3DMsoNormal>&nbsp;{<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; struct pingpong_context&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; *ctx;<o:p><=
/o:p></p>

<p class=3DMsoNormal>@@ -74,6 +74,7 @@<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; size_t &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; guid_coun=
t;<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ib_net64_t&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp; *ca_guid_array;<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; int &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; counter;<o:p></o:p></p>

<p class=3DMsoNormal>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp; int &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp; guid_index
=3D 0;<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ctx =3D malloc(sizeof *ctx);<o:p></o:p=
></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; if (!ctx){<o:p></o:p></p>

<p class=3DMsoNormal>@@ -159,7 +160,28 @@<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;* Open only the first HCA<o:p></=
o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;*/<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; /* Open the CA */<o:p></o:p></p>

<p class=3DMsoNormal>-&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp; ib_status =3D ib_open_ca(ctx-&gt;al
,ca_guid_array[0] ,NULL,<o:p></o:p></p>

<p class=3DMsoNormal>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp; if (ib_devguid) <o:p></o:p></p>

<p class=3DMsoNormal>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp; {<o:p></o:p></p>

<p class=3DMsoNormal>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; unsigned int i =3D 0;<o:p></o:p></=
p>

<p class=3DMsoNormal>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; guid_index =3D -1;<o:p></o:p></p>

<p class=3DMsoNormal>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; for (i =3D 0; i &lt; guid_count;
i++)<o:p></o:p></p>

<p class=3DMsoNormal>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; {<o:p></o:p></p>

<p class=3DMsoNormal>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; char
curr_dev[20];<o:p></o:p></p>

<p class=3DMsoNormal>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; sprintf(curr_=
dev,
&quot;0x%016I64x&quot;, ntohll(ca_guid_array[i]));<o:p></o:p></p>

<p class=3DMsoNormal>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; if
(!_stricmp(ib_devguid, curr_dev))<o:p></o:p></p>

<p class=3DMsoNormal>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; {<o:p></o:p><=
/p>

<p class=3DMsoNormal>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp; guid_index
=3D i;<o:p></o:p></p>

<p class=3DMsoNormal>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp; break;<o:p></o:p></p>

<p class=3DMsoNormal>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; }<o:p></o:p><=
/p>

<p class=3DMsoNormal>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; }<o:p></o:p></p>

<p class=3DMsoNormal>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; if (guid_index =3D=3D -1)<o:p></o:=
p></p>

<p class=3DMsoNormal>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; {<o:p></o:p></p>

<p class=3DMsoNormal>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; fprintf(stder=
r,&quot;device
with guid %s was not found\n&quot;, ib_devguid);<o:p></o:p></p>

<p class=3DMsoNormal>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; return NULL;<=
o:p></o:p></p>

<p class=3DMsoNormal>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; }<o:p></o:p></p>

<p class=3DMsoNormal>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp; }<o:p></o:p></p>

<p class=3DMsoNormal>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp; <o:p></o:p></p>

<p class=3DMsoNormal>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp; ib_status =3D ib_open_ca(ctx-&gt;al
,ca_guid_array[guid_index] ,NULL,<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; NULL,&nbsp;&nbsp;=
&nbsp; //ca_context<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &amp;ctx-&gt;ca);=
<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;<o:p></o:p></p>

<p class=3DMsoNormal>@@ -476,6 +498,7 @@<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; printf(&quot;\n&quot;);<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; printf(&quot;Options:\n&quot;);<o:p></=
o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; printf(&quot;&nbsp; -p,
--port=3D&lt;port&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; liste=
n on/connect to port &lt;port&gt; (default
18515)\n&quot;);<o:p></o:p></p>

<p class=3DMsoNormal>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp; printf(&quot;&nbsp; -d, --ib-dev=3D&lt;dev&gt;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
use IB device &lt;device guid&gt; (default first device found)\n&quot;);<o:=
p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; printf(&quot;&nbsp; -i,
--ib-port=3D&lt;port&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; use port &lt;port&gt=
; of IB device (default
1)\n&quot;);<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; printf(&quot;&nbsp; -c,
--connection=3D&lt;RC/UC&gt;&nbsp; connection type RC/UC (default RC)\n&quo=
t;);<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; printf(&quot;&nbsp; -m,
--mtu=3D&lt;mtu&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp; mtu size (default 1024)\n&quot;);<o:p></o:p></p>

<p class=3DMsoNormal>@@ -650,7 +673,7 @@<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; struct pingpong_dest&nbsp;&nbsp;&nbsp;=
&nbsp; *my_dest;<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; struct pingpong_dest&nbsp;&nbsp;&nbsp;=
&nbsp; *rem_dest;<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; struct user_parameters&nbsp; user_para=
m;<o:p></o:p></p>

<p class=3DMsoNormal>-&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp; char&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; *ib_devname
=3D NULL;<o:p></o:p></p>

<p class=3DMsoNormal>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp; char&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; *ib_devguid
=3D NULL;<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; int&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp; port
=3D 18515;<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; int&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp; ib_port
=3D 1;<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; unsigned&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp; size
=3D 65536;<o:p></o:p></p>

<p class=3DMsoNormal>@@ -661,6 +684,9 @@<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; int&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp; duplex
=3D 0;<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;<o:p></o:p></p>

<p class=3DMsoNormal>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp; SYSTEM_INFO si;<o:p></o:p></p>

<p class=3DMsoNormal>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp; GetSystemInfo(&amp;si);<o:p></o:p></p>

<p class=3DMsoNormal>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp; <o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; /* init default values to user's param=
eters
*/<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; memset(&amp;user_param, 0, sizeof(stru=
ct
user_parameters));<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; user_param.mtu =3D 0;<o:p></o:p></p>

<p class=3DMsoNormal>@@ -705,7 +731,7 @@<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp; break;<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; case 'd':<o:p></o=
:p></p>

<p class=3DMsoNormal>-&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ib_devn=
ame =3D
_strdup(optarg);<o:p></o:p></p>

<p class=3DMsoNormal>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ib_devguid =
=3D
_strdup(optarg);<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp; break;<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; case 'c':<o:p></o=
:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp; if
(strcmp(&quot;UC&quot;,optarg)=3D=3D0)<o:p></o:p></p>

<p class=3DMsoNormal>@@ -814,13 +840,9 @@<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; }<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; srand(GetCurrentProcessId() *
GetTickCount());<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;<o:p></o:p></p>

<p class=3DMsoNormal>-&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp; //TODO: get pagesize from sysinfo<o:p></o:p></p>

<p class=3DMsoNormal>-&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp; page_size =3D 4096;<o:p></o:p></p>

<p class=3DMsoNormal>-<o:p></o:p></p>

<p class=3DMsoNormal>-&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp; //TODO&nbsp; get the device names<o:p></o:p></p>

<p class=3DMsoNormal>-<o:p></o:p></p>

<p class=3DMsoNormal>-<o:p></o:p></p>

<p class=3DMsoNormal>-&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp; ctx =3D pp_init_ctx(size, ib_port,
&amp;user_param);<o:p></o:p></p>

<p class=3DMsoNormal>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp; page_size =3D si.dwPageSize;<o:p></o:p></p>

<p class=3DMsoNormal>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp; <o:p></o:p></p>

<p class=3DMsoNormal>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp; ctx =3D pp_init_ctx(size, ib_port,
&amp;user_param, ib_devguid);<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; if (!ctx)<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; return 8;<o:p></o=
:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; sockfd =3D pp_open_port(ctx,
user_param.servername, ib_port,
port,&amp;my_dest,&amp;rem_dest,&amp;user_param);<o:p></o:p></p>

<p class=3DMsoNormal>Index:
D:/Windows/MLNX_VPI/tools/perftests/user/send_lat/SOURCES<o:p></o:p></p>

<p class=3DMsoNormal>=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D<o:=
p></o:p></p>

<p class=3DMsoNormal>---
D:/Windows/MLNX_VPI/tools/perftests/user/send_lat/SOURCES&nbsp;&nbsp;&nbsp;=
 (revision 6545)<o:p></o:p></p>

<p class=3DMsoNormal>+++
D:/Windows/MLNX_VPI/tools/perftests/user/send_lat/SOURCES (revision 6546)<o=
:p></o:p></p>

<p class=3DMsoNormal>@@ -11,7 +11,7 @@<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ..\perf_utils.c \<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; send_lat.c <o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;<o:p></o:p></p>

<p class=3DMsoNormal>-INCLUDES=3D..;..\..\..\..\inc;..\..\..\..\inc\user<o:=
p></o:p></p>

<p class=3DMsoNormal>+INCLUDES=3D..;..\..\..\..\inc;..\..\..\..\inc\user;..=
\..\..\..\hw\mlx4\user\hca;..\..\..\..\inc\complib<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;RCOPTIONS=3D/I..\..\win\include<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;<o:p></o:p></p>

<p class=3DMsoNormal>Index: D:/Windows/MLNX_VPI/tools/perftests/user/send_l=
at/send_lat.c<o:p></o:p></p>

<p class=3DMsoNormal>=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D<o:=
p></o:p></p>

<p class=3DMsoNormal>---
D:/Windows/MLNX_VPI/tools/perftests/user/send_lat/send_lat.c&nbsp; (revisio=
n 6545)<o:p></o:p></p>

<p class=3DMsoNormal>+++
D:/Windows/MLNX_VPI/tools/perftests/user/send_lat/send_lat.c&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; (revi=
sion
6546)<o:p></o:p></p>

<p class=3DMsoNormal>@@ -38,6 +38,7 @@<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;#include &quot;getopt.h&quot;<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;#include &quot;get_clock.h&quot;<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;#include &quot;perf_defs.h&quot;<o:p></o:p></p>

<p class=3DMsoNormal>+#include &quot;l2w.h&quot;<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;<o:p></o:p></p>

<p class=3DMsoNormal>@@ -67,12 +68,13 @@<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;}<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;<o:p></o:p></p>

<p class=3DMsoNormal>-static struct pingpong_context *pp_init_ctx(unsigned =
int
size,int port,struct user_parameters *user_parm) {<o:p></o:p></p>

<p class=3DMsoNormal>+static struct pingpong_context *pp_init_ctx(unsigned =
int
size,int port,struct user_parameters *user_parm, char* ib_devguid) {<o:p></=
o:p></p>

<p class=3DMsoNormal>&nbsp;<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; struct pingpong_context&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; *ctx;<o:p><=
/o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ib_api_status_t &nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ib_status
=3D IB_SUCCESS;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp; <o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; size_t &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; guid_coun=
t;<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ib_net64_t&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp; *ca_guid_array;<o:p></o:p></p>

<p class=3DMsoNormal>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp; int &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp; guid_index
=3D 0;<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <o:p></o:p></p>

<p class=3DMsoNormal>@@ -156,7 +158,29 @@<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;* Open only the first HCA<o:p></=
o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;*/<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; /* Open the CA */<o:p></o:p></p>

<p class=3DMsoNormal>-&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp; ib_status =3D ib_open_ca(ctx-&gt;al
,ca_guid_array[0] ,NULL,<o:p></o:p></p>

<p class=3DMsoNormal>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp; if (ib_devguid) <o:p></o:p></p>

<p class=3DMsoNormal>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp; {<o:p></o:p></p>

<p class=3DMsoNormal>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; unsigned int i =3D 0;<o:p></o:p></=
p>

<p class=3DMsoNormal>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; guid_index =3D -1;<o:p></o:p></p>

<p class=3DMsoNormal>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; for (i =3D 0; i &lt; guid_count;
i++)<o:p></o:p></p>

<p class=3DMsoNormal>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; {<o:p></o:p></p>

<p class=3DMsoNormal>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; char
curr_dev[20];<o:p></o:p></p>

<p class=3DMsoNormal>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; sprintf(curr_=
dev,
&quot;0x%016I64x&quot;, ntohll(ca_guid_array[i]));<o:p></o:p></p>

<p class=3DMsoNormal>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; if
(!_stricmp(ib_devguid, curr_dev))<o:p></o:p></p>

<p class=3DMsoNormal>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; {<o:p></o:p><=
/p>

<p class=3DMsoNormal>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp; guid_index
=3D i;<o:p></o:p></p>

<p class=3DMsoNormal>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp; break;<o:p></o:p></p>

<p class=3DMsoNormal>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; }<o:p></o:p><=
/p>

<p class=3DMsoNormal>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; }<o:p></o:p></p>

<p class=3DMsoNormal>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; if (guid_index =3D=3D -1)<o:p></o:=
p></p>

<p class=3DMsoNormal>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; {<o:p></o:p></p>

<p class=3DMsoNormal>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; fprintf(stder=
r,&quot;device
with guid %s was not found\n&quot;, ib_devguid);<o:p></o:p></p>

<p class=3DMsoNormal>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; return NULL;<=
o:p></o:p></p>

<p class=3DMsoNormal>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; }<o:p></o:p></p>

<p class=3DMsoNormal>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp; }<o:p></o:p></p>

<p class=3DMsoNormal>+<o:p></o:p></p>

<p class=3DMsoNormal>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp; <o:p></o:p></p>

<p class=3DMsoNormal>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp; ib_status =3D ib_open_ca(ctx-&gt;al
,ca_guid_array[guid_index] ,NULL,<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; NULL,&nbsp;&nbsp;=
&nbsp; //ca_context<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &amp;ctx-&gt;ca);=
<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;<o:p></o:p></p>

<p class=3DMsoNormal>@@ -536,6 +560,7 @@<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; printf(&quot;\n&quot;);<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; printf(&quot;Options:\n&quot;);<o:p></=
o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; printf(&quot;&nbsp; -p,
--port=3D&lt;port&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp; listen on/connect to port &lt;port&gt; (default
18515)\n&quot;);<o:p></o:p></p>

<p class=3DMsoNormal>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp; printf(&quot;&nbsp; -d,
--ib-dev=3D&lt;dev&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp; use IB device &lt;device guid&gt; (default first
device found)\n&quot;);<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; printf(&quot;&nbsp; -c,
--connection=3D&lt;RC/UC&gt;&nbsp;&nbsp;&nbsp;&nbsp; connection type RC/UC =
(default RC)\n&quot;);<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; printf(&quot;&nbsp; -m,
--mtu=3D&lt;mtu&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp; mtu size (default 2048)\n&quot;);<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; printf(&quot;&nbsp; -i,
--ib-port=3D&lt;port&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; us=
e port &lt;port&gt; of IB device (default
1)\n&quot;);<o:p></o:p></p>

<p class=3DMsoNormal>@@ -793,7 +818,7 @@<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; struct pingpong_dest&nbsp;&nbsp;&nbsp;=
&nbsp; *my_dest;<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; struct pingpong_dest&nbsp;&nbsp;&nbsp;=
&nbsp; *rem_dest;<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; struct user_parameters&nbsp; user_para=
m;<o:p></o:p></p>

<p class=3DMsoNormal>-&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp; char&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; *ib_devname
=3D NULL;<o:p></o:p></p>

<p class=3DMsoNormal>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp; char&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; *ib_devguid
=3D NULL;<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; int&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp; port
=3D 18515;<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; int&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp; ib_port
=3D 1;<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; unsigned&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp; size
=3D 2;<o:p></o:p></p>

<p class=3DMsoNormal>@@ -806,6 +831,9 @@<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; struct report_options&nbsp;&nbsp;&nbsp=
; report =3D {0};<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;<o:p></o:p></p>

<p class=3DMsoNormal>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp; SYSTEM_INFO si;<o:p></o:p></p>

<p class=3DMsoNormal>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp; GetSystemInfo(&amp;si);<o:p></o:p></p>

<p class=3DMsoNormal>+<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; /* init default values to user's param=
eters
*/<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; memset(&amp;user_param, 0, sizeof(stru=
ct
user_parameters));<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; user_param.mtu =3D 0;<o:p></o:p></p>

<p class=3DMsoNormal>@@ -867,7 +895,7 @@<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp; return 0;<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp; break;<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; case 'd':<o:p></o=
:p></p>

<p class=3DMsoNormal>-&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ib_devn=
ame =3D
_strdup(optarg);<o:p></o:p></p>

<p class=3DMsoNormal>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ib_devguid =
=3D
_strdup(optarg);<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp; break;<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; case 'i':<o:p></o=
:p></p>

<p class=3DMsoNormal>@@ -967,12 +995,9 @@<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; srand(GetCurrentProcessId() *
GetTickCount());<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;<o:p></o:p></p>

<p class=3DMsoNormal>-&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp; //TODO: get pagesize from sysinfo<o:p></o:p></p>

<p class=3DMsoNormal>-&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp; page_size =3D 4096;<o:p></o:p></p>

<p class=3DMsoNormal>-<o:p></o:p></p>

<p class=3DMsoNormal>-&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp; //TODO&nbsp; get the device names<o:p></o:p></p>

<p class=3DMsoNormal>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp; page_size =3D si.dwPageSize;<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <o:p></o:p></p>

<p class=3DMsoNormal>-&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp; ctx =3D pp_init_ctx( size,
ib_port,&amp;user_param);<o:p></o:p></p>

<p class=3DMsoNormal>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp; ctx =3D pp_init_ctx( size,
ib_port,&amp;user_param, ib_devguid);<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; if (!ctx)<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; return 8;<o:p></o=
:p></p>

<p class=3DMsoNormal>&nbsp;<o:p></o:p></p>

<p class=3DMsoNormal>Index: D:/Windows/MLNX_VPI/tools/perftests/user/write_=
lat/SOURCES<o:p></o:p></p>

<p class=3DMsoNormal>=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D<o:=
p></o:p></p>

<p class=3DMsoNormal>---
D:/Windows/MLNX_VPI/tools/perftests/user/write_lat/SOURCES&nbsp;&nbsp;&nbsp=
; (revision 6545)<o:p></o:p></p>

<p class=3DMsoNormal>+++
D:/Windows/MLNX_VPI/tools/perftests/user/write_lat/SOURCES (revision 6546)<=
o:p></o:p></p>

<p class=3DMsoNormal>@@ -11,7 +11,7 @@<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ..\perf_utils.c \<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; write_lat.c <o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;<o:p></o:p></p>

<p class=3DMsoNormal>-INCLUDES=3D..;..\..\..\..\inc;..\..\..\..\inc\user<o:=
p></o:p></p>

<p class=3DMsoNormal>+INCLUDES=3D..;..\..\..\..\inc;..\..\..\..\inc\user;..=
\..\..\..\hw\mlx4\user\hca;..\..\..\..\inc\complib<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;RCOPTIONS=3D/I..\..\win\include<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;<o:p></o:p></p>

<p class=3DMsoNormal>Index: D:/Windows/MLNX_VPI/tools/perftests/user/write_=
lat/write_lat.c<o:p></o:p></p>

<p class=3DMsoNormal>=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D<o:=
p></o:p></p>

<p class=3DMsoNormal>---
D:/Windows/MLNX_VPI/tools/perftests/user/write_lat/write_lat.c (revision 65=
45)<o:p></o:p></p>

<p class=3DMsoNormal>+++
D:/Windows/MLNX_VPI/tools/perftests/user/write_lat/write_lat.c&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; (revision
6546)<o:p></o:p></p>

<p class=3DMsoNormal>@@ -38,6 +38,7 @@<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;#include &quot;getopt.h&quot;<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;#include &quot;perf_defs.h&quot;<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;#include &quot;get_clock.h&quot;<o:p></o:p></p>

<p class=3DMsoNormal>+#include &quot;l2w.h&quot;<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;<o:p></o:p></p>

<p class=3DMsoNormal>@@ -68,7 +69,7 @@<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;}<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;<o:p></o:p></p>

<p class=3DMsoNormal>-static struct pingpong_context *pp_init_ctx(unsigned =
size,
int port, struct user_parameters *user_parm)<o:p></o:p></p>

<p class=3DMsoNormal>+static struct pingpong_context *pp_init_ctx(unsigned =
size,
int port, struct user_parameters *user_parm, char* ib_devguid)<o:p></o:p></=
p>

<p class=3DMsoNormal>&nbsp;{<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;<o:p></o:p></p>

<p class=3DMsoNormal>@@ -76,6 +77,7 @@<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ib_api_status_t &nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ib_status
=3D IB_SUCCESS;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp; <o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; size_t &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; guid_coun=
t;<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ib_net64_t&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp; *ca_guid_array;<o:p></o:p></p>

<p class=3DMsoNormal>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp; int&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; guid_index
=3D 0;<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ctx =3D malloc(sizeof *ctx);<o:p></o:p=
></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; if (!ctx){<o:p></o:p></p>

<p class=3DMsoNormal>@@ -150,7 +152,28 @@<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;* Open only the first HCA<o:p></=
o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;*/<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; /* Open the CA */<o:p></o:p></p>

<p class=3DMsoNormal>-&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp; ib_status =3D ib_open_ca(ctx-&gt;al
,ca_guid_array[0] ,NULL,<o:p></o:p></p>

<p class=3DMsoNormal>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp; if (ib_devguid) <o:p></o:p></p>

<p class=3DMsoNormal>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp; {<o:p></o:p></p>

<p class=3DMsoNormal>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; unsigned int i =3D 0;<o:p></o:p></=
p>

<p class=3DMsoNormal>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; guid_index =3D -1;<o:p></o:p></p>

<p class=3DMsoNormal>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; for (i =3D 0; i &lt; guid_count;
i++)<o:p></o:p></p>

<p class=3DMsoNormal>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; {<o:p></o:p></p>

<p class=3DMsoNormal>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; char
curr_dev[20];<o:p></o:p></p>

<p class=3DMsoNormal>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; sprintf(curr_=
dev,
&quot;0x%016I64x&quot;, ntohll(ca_guid_array[i]));<o:p></o:p></p>

<p class=3DMsoNormal>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; if
(!_stricmp(ib_devguid, curr_dev))<o:p></o:p></p>

<p class=3DMsoNormal>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; {<o:p></o:p><=
/p>

<p class=3DMsoNormal>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp; guid_index
=3D i;<o:p></o:p></p>

<p class=3DMsoNormal>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp; break;<o:p></o:p></p>

<p class=3DMsoNormal>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; }<o:p></o:p><=
/p>

<p class=3DMsoNormal>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; }<o:p></o:p></p>

<p class=3DMsoNormal>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; if (guid_index =3D=3D -1)<o:p></o:=
p></p>

<p class=3DMsoNormal>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; {<o:p></o:p></p>

<p class=3DMsoNormal>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; fprintf(stder=
r,&quot;device
with guid %s was not found\n&quot;, ib_devguid);<o:p></o:p></p>

<p class=3DMsoNormal>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; return NULL;<=
o:p></o:p></p>

<p class=3DMsoNormal>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; }<o:p></o:p></p>

<p class=3DMsoNormal>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp; }<o:p></o:p></p>

<p class=3DMsoNormal>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp; <o:p></o:p></p>

<p class=3DMsoNormal>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp; ib_status =3D ib_open_ca(ctx-&gt;al
,ca_guid_array[guid_index] ,NULL,<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; NULL,&nbsp;&nbsp;=
&nbsp; //ca_context<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &amp;ctx-&gt;ca);=
<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;<o:p></o:p></p>

<p class=3DMsoNormal>@@ -465,6 +488,7 @@<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; printf(&quot;\n&quot;);<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; printf(&quot;Options:\n&quot;);<o:p></=
o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; printf(&quot;&nbsp; -p,
--port=3D&lt;port&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp; listen on/connect to port &lt;port&gt; (default
18515)\n&quot;);<o:p></o:p></p>

<p class=3DMsoNormal>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp; printf(&quot;&nbsp; -d, --ib-dev=3D&lt;dev&gt;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
use IB device &lt;device guid&gt; (default first device found)\n&quot;);<o:=
p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; printf(&quot;&nbsp; -c,
--connection=3D&lt;RC/UC&gt;&nbsp;&nbsp;&nbsp;&nbsp; connection type RC/UC =
(default RC)\n&quot;);<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; printf(&quot;&nbsp; -m,
--mtu=3D&lt;mtu&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp; mtu size (default 1024)\n&quot;);<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; printf(&quot;&nbsp; -i,
--ib-port=3D&lt;port&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; us=
e port &lt;port&gt; of IB device (default
1)\n&quot;);<o:p></o:p></p>

<p class=3DMsoNormal>@@ -647,7 +671,7 @@<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; struct pingpong_dest&nbsp;&nbsp;&nbsp;=
&nbsp; *my_dest;<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; struct pingpong_dest&nbsp;&nbsp;&nbsp;=
&nbsp; *rem_dest;<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; struct user_parameters&nbsp; user_para=
m;<o:p></o:p></p>

<p class=3DMsoNormal>-&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp; char&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; *ib_devname
=3D NULL;<o:p></o:p></p>

<p class=3DMsoNormal>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp; char&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; *ib_devguid
=3D NULL;<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; int&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp; port
=3D 18515;<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; int&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp; ib_port
=3D 1;<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; unsigned&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp; size
=3D 2;<o:p></o:p></p>

<p class=3DMsoNormal>@@ -657,6 +681,8 @@<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; int&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp; iResult;
<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; struct report_options&nbsp;&nbsp;&nbsp=
; report =3D {0};<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;<o:p></o:p></p>

<p class=3DMsoNormal>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp; SYSTEM_INFO si;<o:p></o:p></p>

<p class=3DMsoNormal>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp; GetSystemInfo(&amp;si);<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; /* init default values to user's param=
eters
*/<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; memset(&amp;user_param, 0, sizeof(stru=
ct
user_parameters));<o:p></o:p></p>

<p class=3DMsoNormal>@@ -715,7 +741,7 @@<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp; return 0;<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp; break;<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; case 'd':<o:p></o=
:p></p>

<p class=3DMsoNormal>-&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ib_devn=
ame =3D
_strdup(optarg);<o:p></o:p></p>

<p class=3DMsoNormal>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ib_devguid =
=3D
_strdup(optarg);<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp; break;<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; case 'i':<o:p></o=
:p></p>

<p class=3DMsoNormal>@@ -811,13 +837,9 @@<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; }<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; srand(GetCurrentProcessId() *
GetTickCount());<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;<o:p></o:p></p>

<p class=3DMsoNormal>-&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp; //TODO: get pagesize from sysinfo<o:p></o:p></p>

<p class=3DMsoNormal>-&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp; page_size =3D 4096;<o:p></o:p></p>

<p class=3DMsoNormal>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp; page_size =3D si.dwPageSize;<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;<o:p></o:p></p>

<p class=3DMsoNormal>-&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp; //TODO&nbsp; get the device names<o:p></o:p></p>

<p class=3DMsoNormal>-&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp; <o:p></o:p></p>

<p class=3DMsoNormal>-<o:p></o:p></p>

<p class=3DMsoNormal>-&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp; ctx =3D pp_init_ctx( size,
ib_port,&amp;user_param);<o:p></o:p></p>

<p class=3DMsoNormal>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp; ctx =3D pp_init_ctx( size,
ib_port,&amp;user_param, ib_devguid);<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; if (!ctx)<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; return 8;<o:p></o=
:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; sockfd =3D pp_open_port(ctx,
user_param.servername, ib_port,
port,&amp;my_dest,&amp;rem_dest,&amp;user_param);<o:p></o:p></p>

<p class=3DMsoNormal>@@ -846,4 +868,4 @@<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; printf(&quot;-------------------------=
-----------------------------------------\n&quot;);<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; free(tstamp);<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; return 0;<o:p></o:p></p>

<p class=3DMsoNormal>-}<o:p></o:p></p>

<p class=3DMsoNormal>+}<o:p></o:p></p>

<p class=3DMsoNormal>\ No newline at end of file<o:p></o:p></p>

<p class=3DMsoNormal>Index: D:/Windows/MLNX_VPI/tools/perftests/user/read_b=
w/SOURCES<o:p></o:p></p>

<p class=3DMsoNormal>=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D<o:=
p></o:p></p>

<p class=3DMsoNormal>--- D:/Windows/MLNX_VPI/tools/perftests/user/read_bw/S=
OURCES&nbsp;&nbsp;&nbsp; (revision
6545)<o:p></o:p></p>

<p class=3DMsoNormal>+++ D:/Windows/MLNX_VPI/tools/perftests/user/read_bw/S=
OURCES (revision
6546)<o:p></o:p></p>

<p class=3DMsoNormal>@@ -11,7 +11,7 @@<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ..\perf_utils.c \<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; read_bw.c <o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;<o:p></o:p></p>

<p class=3DMsoNormal>-INCLUDES=3D..;..\..\..\..\inc;..\..\..\..\inc\user<o:=
p></o:p></p>

<p class=3DMsoNormal>+INCLUDES=3D..;..\..\..\..\inc;..\..\..\..\inc\user;..=
\..\..\..\hw\mlx4\user\hca;..\..\..\..\inc\complib<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;RCOPTIONS=3D/I..\..\win\include<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;<o:p></o:p></p>

<p class=3DMsoNormal>Index: D:/Windows/MLNX_VPI/tools/perftests/user/read_b=
w/read_bw.c<o:p></o:p></p>

<p class=3DMsoNormal>=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D<o:=
p></o:p></p>

<p class=3DMsoNormal>---
D:/Windows/MLNX_VPI/tools/perftests/user/read_bw/read_bw.c (revision 6545)<=
o:p></o:p></p>

<p class=3DMsoNormal>+++ D:/Windows/MLNX_VPI/tools/perftests/user/read_bw/r=
ead_bw.c&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp; (revision
6546)<o:p></o:p></p>

<p class=3DMsoNormal>@@ -37,6 +37,7 @@<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;#include &quot;getopt.h&quot;<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;#include &quot;perf_defs.h&quot;<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;#include &quot;get_clock.h&quot;<o:p></o:p></p>

<p class=3DMsoNormal>+#include &quot;l2w.h&quot;<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;struct user_parameters {<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; const char&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; *servername;<o:p></o:p><=
/p>

<p class=3DMsoNormal>@@ -64,13 +65,14 @@<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; return ;<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;}<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;<o:p></o:p></p>

<p class=3DMsoNormal>-static struct pingpong_context *pp_init_ctx(unsigned
size,int port, struct user_parameters *user_parm)<o:p></o:p></p>

<p class=3DMsoNormal>+static struct pingpong_context *pp_init_ctx(unsigned
size,int port, struct user_parameters *user_parm, char* ib_devguid)<o:p></o=
:p></p>

<p class=3DMsoNormal>&nbsp;{<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; struct pingpong_context&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; *ctx;<o:p><=
/o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ib_api_status_t &nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ib_status
=3D IB_SUCCESS;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp; <o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; size_t &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; guid_coun=
t;<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ib_net64_t&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp; *ca_guid_array;<o:p></o:p></p>

<p class=3DMsoNormal>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp; int &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp; guid_index
=3D 0;<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ctx =3D malloc(sizeof *ctx);<o:p></o:p=
></p>

<p class=3DMsoNormal>@@ -145,7 +147,28 @@<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;* Open only the first HCA<o:p></=
o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;*/<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; /* Open the CA */<o:p></o:p></p>

<p class=3DMsoNormal>-&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp; ib_status =3D ib_open_ca(ctx-&gt;al
,ca_guid_array[0] ,NULL,<o:p></o:p></p>

<p class=3DMsoNormal>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp; if (ib_devguid) <o:p></o:p></p>

<p class=3DMsoNormal>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp; {<o:p></o:p></p>

<p class=3DMsoNormal>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; unsigned int i =3D 0;<o:p></o:p></=
p>

<p class=3DMsoNormal>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; guid_index =3D -1;<o:p></o:p></p>

<p class=3DMsoNormal>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; for (i =3D 0; i &lt; guid_count;
i++)<o:p></o:p></p>

<p class=3DMsoNormal>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; {<o:p></o:p></p>

<p class=3DMsoNormal>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; char
curr_dev[20];<o:p></o:p></p>

<p class=3DMsoNormal>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; sprintf(curr_=
dev,
&quot;0x%016I64x&quot;, ntohll(ca_guid_array[i]));<o:p></o:p></p>

<p class=3DMsoNormal>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; if
(!_stricmp(ib_devguid, curr_dev))<o:p></o:p></p>

<p class=3DMsoNormal>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; {<o:p></o:p><=
/p>

<p class=3DMsoNormal>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp; guid_index
=3D i;<o:p></o:p></p>

<p class=3DMsoNormal>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp; break;<o:p></o:p></p>

<p class=3DMsoNormal>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; }<o:p></o:p><=
/p>

<p class=3DMsoNormal>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; }<o:p></o:p></p>

<p class=3DMsoNormal>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; if (guid_index =3D=3D -1)<o:p></o:=
p></p>

<p class=3DMsoNormal>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; {<o:p></o:p></p>

<p class=3DMsoNormal>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; fprintf(stder=
r,&quot;device
with guid %s was not found\n&quot;, ib_devguid);<o:p></o:p></p>

<p class=3DMsoNormal>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; return NULL;<=
o:p></o:p></p>

<p class=3DMsoNormal>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; }<o:p></o:p></p>

<p class=3DMsoNormal>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp; }<o:p></o:p></p>

<p class=3DMsoNormal>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp; <o:p></o:p></p>

<p class=3DMsoNormal>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp; ib_status =3D ib_open_ca(ctx-&gt;al
,ca_guid_array[guid_index] ,NULL,<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; NULL,&nbsp;&nbsp;=
&nbsp; //ca_context<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &amp;ctx-&gt;ca);=
<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;<o:p></o:p></p>

<p class=3DMsoNormal>@@ -445,6 +468,7 @@<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; printf(&quot;\n&quot;);<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; printf(&quot;Options:\n&quot;);<o:p></=
o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; printf(&quot;&nbsp; -p, --port=3D&lt;p=
ort&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
listen on/connect to port &lt;port&gt; (default 18515)\n&quot;);<o:p></o:p>=
</p>

<p class=3DMsoNormal>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp; printf(&quot;&nbsp; -d, --ib-dev=3D&lt;dev&gt;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
use IB device &lt;device guid&gt; (default first device found)\n&quot;);<o:=
p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; printf(&quot;&nbsp; -i, --ib-port=3D&l=
t;port&gt;&nbsp;&nbsp;
use port &lt;port&gt; of IB device (default 1)\n&quot;);<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; printf(&quot;&nbsp; -m, --mtu=3D&lt;mt=
u&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
mtu size (default 1024)\n&quot;);<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; printf(&quot;&nbsp; -o, --outs=3D&lt;n=
um&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
num of outstanding read/atom(default 4)\n&quot;);<o:p></o:p></p>

<p class=3DMsoNormal>@@ -582,7 +606,7 @@<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; struct pingpong_dest&nbsp;&nbsp;&nbsp;=
&nbsp; *my_dest;<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; struct pingpong_dest&nbsp;&nbsp;&nbsp;=
&nbsp; *rem_dest;<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; struct user_parameters&nbsp; user_para=
m;<o:p></o:p></p>

<p class=3DMsoNormal>-&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp; char&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; *ib_devname
=3D NULL;<o:p></o:p></p>

<p class=3DMsoNormal>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp; char&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; *ib_devguid
=3D NULL;<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; int&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp; port
=3D 18515;<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; int&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp; ib_port
=3D 1;<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; unsigned&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp; size
=3D 65536;<o:p></o:p></p>

<p class=3DMsoNormal>@@ -592,6 +616,9 @@<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; int&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp; i
=3D 0;<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; int&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp; duplex
=3D 0;<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;<o:p></o:p></p>

<p class=3DMsoNormal>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp; SYSTEM_INFO si;<o:p></o:p></p>

<p class=3DMsoNormal>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp; GetSystemInfo(&amp;si);<o:p></o:p></p>

<p class=3DMsoNormal>+<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; /* init default values to user's param=
eters
*/<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; memset(&amp;user_param, 0, sizeof(stru=
ct
user_parameters));<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; user_param.mtu =3D 0; /* signal choose=
 default
by device */<o:p></o:p></p>

<p class=3DMsoNormal>@@ -632,7 +659,7 @@<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp; break;<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; case 'd':<o:p></o=
:p></p>

<p class=3DMsoNormal>-&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ib_devn=
ame =3D
_strdup(optarg);<o:p></o:p></p>

<p class=3DMsoNormal>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ib_devguid =
=3D
_strdup(optarg);<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp; break;<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; case 'm':<o:p></o=
:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp; user_param.mtu
=3D strtol(optarg, NULL, 0);<o:p></o:p></p>

<p class=3DMsoNormal>@@ -717,13 +744,9 @@<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; srand(GetCurrentProcessId() *
GetTickCount());<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;<o:p></o:p></p>

<p class=3DMsoNormal>-&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp; //TODO: get pagesize from sysinfo<o:p></o:p></p>

<p class=3DMsoNormal>-&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp; page_size =3D 4096;<o:p></o:p></p>

<p class=3DMsoNormal>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp; page_size =3D si.dwPageSize;<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;<o:p></o:p></p>

<p class=3DMsoNormal>-&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp; //TODO:get the device names<o:p></o:p></p>

<p class=3DMsoNormal>-<o:p></o:p></p>

<p class=3DMsoNormal>-<o:p></o:p></p>

<p class=3DMsoNormal>-&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp; ctx =3D pp_init_ctx(size,ib_port,
&amp;user_param);<o:p></o:p></p>

<p class=3DMsoNormal>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp; ctx =3D pp_init_ctx(size,ib_port,
&amp;user_param, ib_devguid);<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; if (!ctx)<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; return 8;<o:p></o=
:p></p>

<p class=3DMsoNormal>&nbsp;<o:p></o:p></p>

<p class=3DMsoNormal>Index:
D:/Windows/MLNX_VPI/tools/perftests/user/read_lat/SOURCES<o:p></o:p></p>

<p class=3DMsoNormal>=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D<o:=
p></o:p></p>

<p class=3DMsoNormal>---
D:/Windows/MLNX_VPI/tools/perftests/user/read_lat/SOURCES&nbsp;&nbsp;&nbsp;=
&nbsp; (revision 6545)<o:p></o:p></p>

<p class=3DMsoNormal>+++
D:/Windows/MLNX_VPI/tools/perftests/user/read_lat/SOURCES&nbsp; (revision 6=
546)<o:p></o:p></p>

<p class=3DMsoNormal>@@ -11,7 +11,7 @@<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ..\perf_utils.c \<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; read_lat.c <o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;<o:p></o:p></p>

<p class=3DMsoNormal>-INCLUDES=3D..;..\..\..\..\inc;..\..\..\..\inc\user<o:=
p></o:p></p>

<p class=3DMsoNormal>+INCLUDES=3D..;..\..\..\..\inc;..\..\..\..\inc\user;..=
\..\..\..\hw\mlx4\user\hca;..\..\..\..\inc\complib<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;RCOPTIONS=3D/I..\..\win\include<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;<o:p></o:p></p>

<p class=3DMsoNormal>Index:
D:/Windows/MLNX_VPI/tools/perftests/user/read_lat/read_lat.c<o:p></o:p></p>

<p class=3DMsoNormal>=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D<o:=
p></o:p></p>

<p class=3DMsoNormal>---
D:/Windows/MLNX_VPI/tools/perftests/user/read_lat/read_lat.c&nbsp;&nbsp;&nb=
sp; (revision 6545)<o:p></o:p></p>

<p class=3DMsoNormal>+++
D:/Windows/MLNX_VPI/tools/perftests/user/read_lat/read_lat.c (revision 6546=
)<o:p></o:p></p>

<p class=3DMsoNormal>@@ -38,6 +38,7 @@<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;#include &quot;getopt.h&quot;<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;#include &quot;perf_defs.h&quot;<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;#include &quot;get_clock.h&quot;<o:p></o:p></p>

<p class=3DMsoNormal>+#include &quot;l2w.h&quot;<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;<o:p></o:p></p>

<p class=3DMsoNormal>@@ -68,7 +69,7 @@<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; return ;<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;}<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;<o:p></o:p></p>

<p class=3DMsoNormal>-static struct pingpong_context *pp_init_ctx(unsigned
size,int port, struct user_parameters *user_parm)<o:p></o:p></p>

<p class=3DMsoNormal>+static struct pingpong_context *pp_init_ctx(unsigned
size,int port, struct user_parameters *user_parm, char* ib_devguid)<o:p></o=
:p></p>

<p class=3DMsoNormal>&nbsp;{<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;<o:p></o:p></p>

<p class=3DMsoNormal>@@ -76,6 +77,7 @@<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ib_api_status_t &nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ib_status
=3D IB_SUCCESS;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp; <o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; size_t &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; guid_coun=
t;<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ib_net64_t&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp; *ca_guid_array;<o:p></o:p></p>

<p class=3DMsoNormal>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp; int&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; guid_index
=3D 0;<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ctx =3D malloc(sizeof *ctx);<o:p></o:p=
></p>

<p class=3DMsoNormal>@@ -149,7 +151,28 @@<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;* Open only the first HCA<o:p></=
o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;*/<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; /* Open the CA */<o:p></o:p></p>

<p class=3DMsoNormal>-&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp; ib_status =3D ib_open_ca(ctx-&gt;al
,ca_guid_array[0] ,NULL,<o:p></o:p></p>

<p class=3DMsoNormal>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp; if (ib_devguid) <o:p></o:p></p>

<p class=3DMsoNormal>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp; {<o:p></o:p></p>

<p class=3DMsoNormal>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; unsigned int i =3D 0;<o:p></o:p></=
p>

<p class=3DMsoNormal>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; guid_index =3D -1;<o:p></o:p></p>

<p class=3DMsoNormal>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; for (i =3D 0; i &lt; guid_count;
i++)<o:p></o:p></p>

<p class=3DMsoNormal>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; {<o:p></o:p></p>

<p class=3DMsoNormal>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; char
curr_dev[20];<o:p></o:p></p>

<p class=3DMsoNormal>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; sprintf(curr_=
dev,
&quot;0x%016I64x&quot;, ntohll(ca_guid_array[i]));<o:p></o:p></p>

<p class=3DMsoNormal>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; if
(!_stricmp(ib_devguid, curr_dev))<o:p></o:p></p>

<p class=3DMsoNormal>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; {<o:p></o:p><=
/p>

<p class=3DMsoNormal>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp; guid_index
=3D i;<o:p></o:p></p>

<p class=3DMsoNormal>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp; break;<o:p></o:p></p>

<p class=3DMsoNormal>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; }<o:p></o:p><=
/p>

<p class=3DMsoNormal>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; }<o:p></o:p></p>

<p class=3DMsoNormal>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; if (guid_index =3D=3D -1)<o:p></o:=
p></p>

<p class=3DMsoNormal>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; {<o:p></o:p></p>

<p class=3DMsoNormal>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; fprintf(stder=
r,&quot;device
with guid %s was not found\n&quot;, ib_devguid);<o:p></o:p></p>

<p class=3DMsoNormal>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; return NULL;<=
o:p></o:p></p>

<p class=3DMsoNormal>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; }<o:p></o:p></p>

<p class=3DMsoNormal>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp; }<o:p></o:p></p>

<p class=3DMsoNormal>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp; <o:p></o:p></p>

<p class=3DMsoNormal>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp; ib_status =3D ib_open_ca(ctx-&gt;al
,ca_guid_array[guid_index] ,NULL,<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; NULL,&nbsp;&nbsp;=
&nbsp; //ca_context<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &amp;ctx-&gt;ca);=
<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;<o:p></o:p></p>

<p class=3DMsoNormal>@@ -456,6 +479,7 @@<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; printf(&quot;\n&quot;);<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; printf(&quot;Options:\n&quot;);<o:p></=
o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; printf(&quot;&nbsp; -p,
--port=3D&lt;port&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp; listen on/connect to port &lt;port&gt; (default
18515)\n&quot;);<o:p></o:p></p>

<p class=3DMsoNormal>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp; printf(&quot;&nbsp; -d,
--ib-dev=3D&lt;dev&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp; use IB device &lt;device guid&gt; (default first
device found)\n&quot;);<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; printf(&quot;&nbsp; -m,
--mtu=3D&lt;mtu&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp; mtu size (default 256)\n&quot;);<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; printf(&quot;&nbsp; -i,
--ib-port=3D&lt;port&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; us=
e port &lt;port&gt; of IB device (default
1)\n&quot;);<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; printf(&quot;&nbsp; -s,
--size=3D&lt;size&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp; size of message to exchange (default
1)\n&quot;);<o:p></o:p></p>

<p class=3DMsoNormal>@@ -598,7 +622,7 @@<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; struct pingpong_dest&nbsp;&nbsp;&nbsp;=
&nbsp; *my_dest;<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; struct pingpong_dest&nbsp;&nbsp;&nbsp;=
&nbsp; *rem_dest;<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; struct user_parameters&nbsp; user_para=
m;<o:p></o:p></p>

<p class=3DMsoNormal>-&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp; char&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; *ib_devname
=3D NULL;<o:p></o:p></p>

<p class=3DMsoNormal>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp; char&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; *ib_devguid
=3D NULL;<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; int&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp; port
=3D 18515;<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; int&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp; ib_port
=3D 1;<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; unsigned&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp; tmp_size,size
=3D 2;<o:p></o:p></p>

<p class=3DMsoNormal>@@ -608,6 +632,8 @@<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; int&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp; i
=3D 0;<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; struct report_options&nbsp;&nbsp;&nbsp=
; report =3D {0};<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;<o:p></o:p></p>

<p class=3DMsoNormal>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp; SYSTEM_INFO si;<o:p></o:p></p>

<p class=3DMsoNormal>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp; GetSystemInfo(&amp;si);<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; /* init default values to user's param=
eters
*/<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; memset(&amp;user_param, 0, sizeof(stru=
ct
user_parameters));<o:p></o:p></p>

<p class=3DMsoNormal>@@ -665,7 +691,7 @@<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp; return 0;<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp; break;<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; case 'd':<o:p></o=
:p></p>

<p class=3DMsoNormal>-&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ib_devn=
ame =3D
_strdup(optarg);<o:p></o:p></p>

<p class=3DMsoNormal>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ib_devguid =
=3D
_strdup(optarg);<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp; break;<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; case 'i':<o:p></o=
:p></p>

<p class=3DMsoNormal>@@ -755,13 +781,9 @@<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; srand(GetCurrentProcessId() *
GetTickCount());<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;<o:p></o:p></p>

<p class=3DMsoNormal>-&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp; //TODO: get pagesize from sysinfo<o:p></o:p></p>

<p class=3DMsoNormal>-&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp; page_size =3D 4096;<o:p></o:p></p>

<p class=3DMsoNormal>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp; page_size =3D si.dwPageSize;<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;<o:p></o:p></p>

<p class=3DMsoNormal>-&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp; //TODO:get the device names<o:p></o:p></p>

<p class=3DMsoNormal>-<o:p></o:p></p>

<p class=3DMsoNormal>-<o:p></o:p></p>

<p class=3DMsoNormal>-&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp; ctx =3D pp_init_ctx(size,ib_port,
&amp;user_param);<o:p></o:p></p>

<p class=3DMsoNormal>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp; ctx =3D pp_init_ctx(size,ib_port,
&amp;user_param, ib_devguid);<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; if (!ctx)<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; return 8;<o:p></o=
:p></p>

<p class=3DMsoNormal><o:p>&nbsp;</o:p></p>

</div>

</body>

</html>

--_000_E113D394D7C5DB4F8FF691FA7EE9DB443BF12865D0MTLMAILmtlcom_--

--_004_E113D394D7C5DB4F8FF691FA7EE9DB443BF12865D0MTLMAILmtlcom_
Content-Type: application/octet-stream; name="ib_tools_dev.patch"
Content-Description: ib_tools_dev.patch
Content-Disposition: attachment; filename="ib_tools_dev.patch"; size=21852;
	creation-date="Sun, 19 Sep 2010 15:55:43 GMT";
	modification-date="Sun, 19 Sep 2010 15:56:06 GMT"
Content-Transfer-Encoding: base64

SW5kZXg6IEQ6L1dpbmRvd3MvTUxOWF9WUEkvdG9vbHMvcGVyZnRlc3RzL3VzZXIvc2VuZF9idy9z
ZW5kX2J3LmMNCj09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT0NCi0tLSBEOi9XaW5kb3dzL01MTlhfVlBJL3Rvb2xzL3BlcmZ0
ZXN0cy91c2VyL3NlbmRfYncvc2VuZF9idy5jCShyZXZpc2lvbiA2NTQ1KQ0KKysrIEQ6L1dpbmRv
d3MvTUxOWF9WUEkvdG9vbHMvcGVyZnRlc3RzL3VzZXIvc2VuZF9idy9zZW5kX2J3LmMJKHJldmlz
aW9uIDY1NDYpDQpAQCAtMzgsNiArMzgsNyBAQA0KICNpbmNsdWRlICJnZXRfY2xvY2suaCIKIAog
I2luY2x1ZGUgInBlcmZfZGVmcy5oIgorI2luY2x1ZGUgImwydy5oIgogCiAjZGVmaW5lIFNJR05B
TCAxCiAjZGVmaW5lIE1BWF9JTkxJTkUgNDAwCkBAIC03MywxMyArNzQsMTQgQEANCiAKIAogc3Rh
dGljIHN0cnVjdCBwaW5ncG9uZ19jb250ZXh0ICpwcF9pbml0X2N0eCh1bnNpZ25lZCBzaXplLGlu
dCBwb3J0LCAKLQkJCQkJc3RydWN0IHVzZXJfcGFyYW1ldGVycyAqdXNlcl9wYXJtKQorCQkJCQlz
dHJ1Y3QgdXNlcl9wYXJhbWV0ZXJzICp1c2VyX3Bhcm0sIGNoYXIqIGliX2Rldmd1aWQpCiB7CiAK
IAlzdHJ1Y3QgcGluZ3BvbmdfY29udGV4dAkqY3R4OwogCWliX2FwaV9zdGF0dXNfdCAJCQlpYl9z
dGF0dXMgPSBJQl9TVUNDRVNTOwkKIAlzaXplX3QgCQkJCQlndWlkX2NvdW50OwogCWliX25ldDY0
X3QJCQkJKmNhX2d1aWRfYXJyYXk7CisJaW50IAkJCQkJZ3VpZF9pbmRleCA9IDA7CiAKIAogCQpA
QCAtMTU4LDcgKzE2MCwyOCBAQA0KIAkgKiBPcGVuIG9ubHkgdGhlIGZpcnN0IEhDQQogCSAqLwog
CS8qIE9wZW4gdGhlIENBICovCi0JaWJfc3RhdHVzID0gaWJfb3Blbl9jYShjdHgtPmFsICxjYV9n
dWlkX2FycmF5WzBdICxOVUxMLAorCWlmIChpYl9kZXZndWlkKSAKKwl7CisJCXVuc2lnbmVkIGlu
dCBpID0gMDsKKwkJZ3VpZF9pbmRleCA9IC0xOworCQlmb3IgKGkgPSAwOyBpIDwgZ3VpZF9jb3Vu
dDsgaSsrKQorCQl7CisJCQljaGFyIGN1cnJfZGV2WzIwXTsKKwkJCXNwcmludGYoY3Vycl9kZXYs
ICIweCUwMTZJNjR4IiwgbnRvaGxsKGNhX2d1aWRfYXJyYXlbaV0pKTsKKwkJCWlmICghX3N0cmlj
bXAoaWJfZGV2Z3VpZCwgY3Vycl9kZXYpKQorCQkJeworCQkJCWd1aWRfaW5kZXggPSBpOworCQkJ
CWJyZWFrOworCQkJfQorCQl9CisJCWlmIChndWlkX2luZGV4ID09IC0xKQorCQl7CisJCQlmcHJp
bnRmKHN0ZGVyciwiZGV2aWNlIHdpdGggZ3VpZCAlcyB3YXMgbm90IGZvdW5kXG4iLCBpYl9kZXZn
dWlkKTsKKwkJCXJldHVybiBOVUxMOworCQl9CisJfQorCQorCWliX3N0YXR1cyA9IGliX29wZW5f
Y2EoY3R4LT5hbCAsY2FfZ3VpZF9hcnJheVtndWlkX2luZGV4XSAsTlVMTCwKIAkJTlVMTCwJLy9j
YV9jb250ZXh0CiAJCSZjdHgtPmNhKTsKIApAQCAtNTQ5LDYgKzU3Miw3IEBADQogCXByaW50Zigi
XG4iKTsKIAlwcmludGYoIk9wdGlvbnM6XG4iKTsKIAlwcmludGYoIiAgLXAsIC0tcG9ydD08cG9y
dD4gICAgICAgICBsaXN0ZW4gb24vY29ubmVjdCB0byBwb3J0IDxwb3J0PiAoZGVmYXVsdCAxODUx
NSlcbiIpOworCXByaW50ZigiICAtZCwgLS1pYi1kZXY9PGRldj4gICAgICAgIHVzZSBJQiBkZXZp
Y2UgPGRldmljZSBndWlkPiAoZGVmYXVsdCBmaXJzdCBkZXZpY2UgZm91bmQpXG4iKTsKIAlwcmlu
dGYoIiAgLWksIC0taWItcG9ydD08cG9ydD4gICAgICB1c2UgcG9ydCA8cG9ydD4gb2YgSUIgZGV2
aWNlIChkZWZhdWx0IDEpXG4iKTsKIAlwcmludGYoIiAgLWMsIC0tY29ubmVjdGlvbj08UkMvVUM+
ICBjb25uZWN0aW9uIHR5cGUgUkMvVUMvVUQgKGRlZmF1bHQgUkMpXG4iKTsKIAlwcmludGYoIiAg
LW0sIC0tbXR1PTxtdHU+ICAgICAgICAgICBtdHUgc2l6ZSAoZGVmYXVsdCAxMDI0KVxuIik7CkBA
IC05NDMsNyArOTY3LDcgQEANCiAJc3RydWN0IHBpbmdwb25nX2Rlc3QJCSpteV9kZXN0OwogCXN0
cnVjdCBwaW5ncG9uZ19kZXN0CQkqcmVtX2Rlc3Q7CiAJc3RydWN0IHVzZXJfcGFyYW1ldGVycwkJ
dXNlcl9wYXJhbTsKLQljaGFyCQkJCSppYl9kZXZuYW1lID0gTlVMTDsKKwljaGFyCQkJCSppYl9k
ZXZndWlkID0gTlVMTDsKIAlpbnQJCQkJcG9ydCA9IDE4NTE1OwogCWludAkJCQlpYl9wb3J0ID0g
MTsKIAl1bnNpZ25lZAkJCXNpemUgPSA2NTUzNjsKQEAgLTk1Myw2ICs5NzcsOCBAQA0KIAlXU0FE
QVRBCQkJCXdzYURhdGE7CiAJaW50CQkJCWlSZXN1bHQ7CiAKKwlTWVNURU1fSU5GTyBzaTsKKwlH
ZXRTeXN0ZW1JbmZvKCZzaSk7CiAKIAkvKiBpbml0IGRlZmF1bHQgdmFsdWVzIHRvIHVzZXIncyBw
YXJhbWV0ZXJzICovCiAJbWVtc2V0KCZ1c2VyX3BhcmFtLCAwLCBzaXplb2Yoc3RydWN0IHVzZXJf
cGFyYW1ldGVycykpOwpAQCAtOTk4LDcgKzEwMjQsNyBAQA0KIAkJCSsrdXNlcl9wYXJhbS51c2Vf
ZXZlbnQ7CiAJCQlicmVhazsKIAkJY2FzZSAnZCc6Ci0JCQlpYl9kZXZuYW1lID0gX3N0cmR1cChv
cHRhcmcpOworCQkJaWJfZGV2Z3VpZCA9IF9zdHJkdXAob3B0YXJnKTsKIAkJCWJyZWFrOwogCQlj
YXNlICdjJzoKIAkJCWlmIChzdHJjbXAoIlVDIixvcHRhcmcpPT0wKQpAQCAtMTEwMCwxNCArMTEy
NiwxMSBAQA0KIAkKIAlzcmFuZChHZXRDdXJyZW50UHJvY2Vzc0lkKCkgKiBHZXRUaWNrQ291bnQo
KSk7CiAKLQkvL1RPRE86IGdldCBwYWdlc2l6ZSBmcm9tIHN5c2luZm8KLQlwYWdlX3NpemUgPSA0
MDk2OworCXBhZ2Vfc2l6ZSA9IHNpLmR3UGFnZVNpemU7CiAKLQkvL1RPRE86Z2V0IHRoZSBkZXZp
Y2UgbmFtZXMKLQkKIAogCS8vIGluaXQgdGhlIGNvbnRleHQKLQljdHggPSBwcF9pbml0X2N0eChz
aXplLCBpYl9wb3J0LCAmdXNlcl9wYXJhbSk7CisJY3R4ID0gcHBfaW5pdF9jdHgoc2l6ZSwgaWJf
cG9ydCwgJnVzZXJfcGFyYW0sIGliX2Rldmd1aWQpOwogCWlmICghY3R4KQogCQlyZXR1cm4gMTsK
IAkKSW5kZXg6IEQ6L1dpbmRvd3MvTUxOWF9WUEkvdG9vbHMvcGVyZnRlc3RzL3VzZXIvc2VuZF9i
dy9TT1VSQ0VTDQo9PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09DQotLS0gRDovV2luZG93cy9NTE5YX1ZQSS90b29scy9wZXJm
dGVzdHMvdXNlci9zZW5kX2J3L1NPVVJDRVMJKHJldmlzaW9uIDY1NDUpDQorKysgRDovV2luZG93
cy9NTE5YX1ZQSS90b29scy9wZXJmdGVzdHMvdXNlci9zZW5kX2J3L1NPVVJDRVMJKHJldmlzaW9u
IDY1NDYpDQpAQCAtMTEsNyArMTEsNyBAQA0KIAkuLlxwZXJmX3V0aWxzLmMgXA0KIAlzZW5kX2J3
LmMgDQogDQotSU5DTFVERVM9Li47Li5cLi5cLi5cLi5caW5jOy4uXC4uXC4uXC4uXGluY1x1c2Vy
DQorSU5DTFVERVM9Li47Li5cLi5cLi5cLi5caW5jOy4uXC4uXC4uXC4uXGluY1x1c2VyOy4uXC4u
XC4uXC4uXGh3XG1seDRcdXNlclxoY2E7Li5cLi5cLi5cLi5caW5jXGNvbXBsaWINCiANCiBSQ09Q
VElPTlM9L0kuLlwuLlx3aW5caW5jbHVkZQ0KIA0KSW5kZXg6IEQ6L1dpbmRvd3MvTUxOWF9WUEkv
dG9vbHMvcGVyZnRlc3RzL3VzZXIvd3JpdGVfYncvU09VUkNFUw0KPT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PQ0KLS0tIEQ6
L1dpbmRvd3MvTUxOWF9WUEkvdG9vbHMvcGVyZnRlc3RzL3VzZXIvd3JpdGVfYncvU09VUkNFUwko
cmV2aXNpb24gNjU0NSkNCisrKyBEOi9XaW5kb3dzL01MTlhfVlBJL3Rvb2xzL3BlcmZ0ZXN0cy91
c2VyL3dyaXRlX2J3L1NPVVJDRVMJKHJldmlzaW9uIDY1NDYpDQpAQCAtMTEsNyArMTEsNyBAQA0K
IAkuLlxwZXJmX3V0aWxzLmMgXA0KIAl3cml0ZV9idy5jIA0KIA0KLUlOQ0xVREVTPS4uOy4uXC4u
XC4uXC4uXGluYzsuLlwuLlwuLlwuLlxpbmNcdXNlcg0KK0lOQ0xVREVTPS4uOy4uXC4uXC4uXC4u
XGluYzsuLlwuLlwuLlwuLlxpbmNcdXNlcjsuLlwuLlwuLlwuLlxod1xtbHg0XHVzZXJcaGNhOy4u
XC4uXC4uXC4uXGluY1xjb21wbGliDQogDQogUkNPUFRJT05TPS9JLi5cLi5cd2luXGluY2x1ZGUN
CiANCkluZGV4OiBEOi9XaW5kb3dzL01MTlhfVlBJL3Rvb2xzL3BlcmZ0ZXN0cy91c2VyL3dyaXRl
X2J3L3dyaXRlX2J3LmMNCj09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT0NCi0tLSBEOi9XaW5kb3dzL01MTlhfVlBJL3Rvb2xz
L3BlcmZ0ZXN0cy91c2VyL3dyaXRlX2J3L3dyaXRlX2J3LmMJKHJldmlzaW9uIDY1NDUpDQorKysg
RDovV2luZG93cy9NTE5YX1ZQSS90b29scy9wZXJmdGVzdHMvdXNlci93cml0ZV9idy93cml0ZV9i
dy5jCShyZXZpc2lvbiA2NTQ2KQ0KQEAgLTM0LDEyICszNCwxMiBAQA0KICAqICRJZCQKICAqLwog
IAorCiAjaW5jbHVkZSAiZ2V0b3B0LmgiCiAjaW5jbHVkZSAicGVyZl9kZWZzLmgiCiAjaW5jbHVk
ZSAiZ2V0X2Nsb2NrLmgiCisjaW5jbHVkZSAibDJ3LmgiCiAKLQotCiBzdHJ1Y3QgdXNlcl9wYXJh
bWV0ZXJzIHsKIAljb25zdCBjaGFyICAgICAgICAgICAgICAqc2VydmVybmFtZTsKIAlpbnQgY29u
bmVjdGlvbl90eXBlOwpAQCAtNjYsNyArNjYsNyBAQA0KIAlVTlVTRURfUEFSQU0oIGNxX2NvbnRl
eHQpOwogCXJldHVybiA7CiB9Ci1zdGF0aWMgc3RydWN0IHBpbmdwb25nX2NvbnRleHQgKnBwX2lu
aXRfY3R4KHVuc2lnbmVkIHNpemUsIGludCBwb3J0LCBzdHJ1Y3QgdXNlcl9wYXJhbWV0ZXJzICp1
c2VyX3Bhcm0pCitzdGF0aWMgc3RydWN0IHBpbmdwb25nX2NvbnRleHQgKnBwX2luaXRfY3R4KHVu
c2lnbmVkIHNpemUsIGludCBwb3J0LCBzdHJ1Y3QgdXNlcl9wYXJhbWV0ZXJzICp1c2VyX3Bhcm0s
IGNoYXIqIGliX2Rldmd1aWQpCiB7CiAKIAlzdHJ1Y3QgcGluZ3BvbmdfY29udGV4dAkqY3R4OwpA
QCAtNzQsNiArNzQsNyBAQA0KIAlzaXplX3QgCQkJCQlndWlkX2NvdW50OwogCWliX25ldDY0X3QJ
CQkJKmNhX2d1aWRfYXJyYXk7CiAJaW50IAkJCQkJCWNvdW50ZXI7CisJaW50IAkJCQkJZ3VpZF9p
bmRleCA9IDA7CiAKIAljdHggPSBtYWxsb2Moc2l6ZW9mICpjdHgpOwogCWlmICghY3R4KXsKQEAg
LTE1OSw3ICsxNjAsMjggQEANCiAJICogT3BlbiBvbmx5IHRoZSBmaXJzdCBIQ0EKIAkgKi8KIAkv
KiBPcGVuIHRoZSBDQSAqLwotCWliX3N0YXR1cyA9IGliX29wZW5fY2EoY3R4LT5hbCAsY2FfZ3Vp
ZF9hcnJheVswXSAsTlVMTCwKKwlpZiAoaWJfZGV2Z3VpZCkgCisJeworCQl1bnNpZ25lZCBpbnQg
aSA9IDA7CisJCWd1aWRfaW5kZXggPSAtMTsKKwkJZm9yIChpID0gMDsgaSA8IGd1aWRfY291bnQ7
IGkrKykKKwkJeworCQkJY2hhciBjdXJyX2RldlsyMF07CisJCQlzcHJpbnRmKGN1cnJfZGV2LCAi
MHglMDE2STY0eCIsIG50b2hsbChjYV9ndWlkX2FycmF5W2ldKSk7CisJCQlpZiAoIV9zdHJpY21w
KGliX2Rldmd1aWQsIGN1cnJfZGV2KSkKKwkJCXsKKwkJCQlndWlkX2luZGV4ID0gaTsKKwkJCQli
cmVhazsKKwkJCX0KKwkJfQorCQlpZiAoZ3VpZF9pbmRleCA9PSAtMSkKKwkJeworCQkJZnByaW50
ZihzdGRlcnIsImRldmljZSB3aXRoIGd1aWQgJXMgd2FzIG5vdCBmb3VuZFxuIiwgaWJfZGV2Z3Vp
ZCk7CisJCQlyZXR1cm4gTlVMTDsKKwkJfQorCX0KKwkKKwlpYl9zdGF0dXMgPSBpYl9vcGVuX2Nh
KGN0eC0+YWwgLGNhX2d1aWRfYXJyYXlbZ3VpZF9pbmRleF0gLE5VTEwsCiAJCU5VTEwsCS8vY2Ff
Y29udGV4dAogCQkmY3R4LT5jYSk7CiAKQEAgLTQ3Niw2ICs0OTgsNyBAQA0KIAlwcmludGYoIlxu
Iik7CiAJcHJpbnRmKCJPcHRpb25zOlxuIik7CiAJcHJpbnRmKCIgIC1wLCAtLXBvcnQ9PHBvcnQ+
ICAgICAgICAgbGlzdGVuIG9uL2Nvbm5lY3QgdG8gcG9ydCA8cG9ydD4gKGRlZmF1bHQgMTg1MTUp
XG4iKTsKKwlwcmludGYoIiAgLWQsIC0taWItZGV2PTxkZXY+ICAgICAgICB1c2UgSUIgZGV2aWNl
IDxkZXZpY2UgZ3VpZD4gKGRlZmF1bHQgZmlyc3QgZGV2aWNlIGZvdW5kKVxuIik7CiAJcHJpbnRm
KCIgIC1pLCAtLWliLXBvcnQ9PHBvcnQ+ICAgICAgdXNlIHBvcnQgPHBvcnQ+IG9mIElCIGRldmlj
ZSAoZGVmYXVsdCAxKVxuIik7CiAJcHJpbnRmKCIgIC1jLCAtLWNvbm5lY3Rpb249PFJDL1VDPiAg
Y29ubmVjdGlvbiB0eXBlIFJDL1VDIChkZWZhdWx0IFJDKVxuIik7CiAJcHJpbnRmKCIgIC1tLCAt
LW10dT08bXR1PiAgICAgICAgICAgbXR1IHNpemUgKGRlZmF1bHQgMTAyNClcbiIpOwpAQCAtNjUw
LDcgKzY3Myw3IEBADQogCXN0cnVjdCBwaW5ncG9uZ19kZXN0ICAgICAqbXlfZGVzdDsKIAlzdHJ1
Y3QgcGluZ3BvbmdfZGVzdCAgICAgKnJlbV9kZXN0OwogCXN0cnVjdCB1c2VyX3BhcmFtZXRlcnMg
IHVzZXJfcGFyYW07Ci0JY2hhcgkJCQkqaWJfZGV2bmFtZSA9IE5VTEw7CisJY2hhcgkJCQkqaWJf
ZGV2Z3VpZCA9IE5VTEw7CiAJaW50CQkJCXBvcnQgPSAxODUxNTsKIAlpbnQJCQkJaWJfcG9ydCA9
IDE7CiAJdW5zaWduZWQJCQlzaXplID0gNjU1MzY7CkBAIC02NjEsNiArNjg0LDkgQEANCiAJaW50
CQkJCWR1cGxleCA9IDA7CiAKIAorCVNZU1RFTV9JTkZPIHNpOworCUdldFN5c3RlbUluZm8oJnNp
KTsKKwkKIAkvKiBpbml0IGRlZmF1bHQgdmFsdWVzIHRvIHVzZXIncyBwYXJhbWV0ZXJzICovCiAJ
bWVtc2V0KCZ1c2VyX3BhcmFtLCAwLCBzaXplb2Yoc3RydWN0IHVzZXJfcGFyYW1ldGVycykpOwog
CXVzZXJfcGFyYW0ubXR1ID0gMDsKQEAgLTcwNSw3ICs3MzEsNyBAQA0KIAkJCWJyZWFrOwogCiAJ
CWNhc2UgJ2QnOgotCQkJaWJfZGV2bmFtZSA9IF9zdHJkdXAob3B0YXJnKTsKKwkJCWliX2Rldmd1
aWQgPSBfc3RyZHVwKG9wdGFyZyk7CiAJCQlicmVhazsKIAkJY2FzZSAnYyc6CiAJCQlpZiAoc3Ry
Y21wKCJVQyIsb3B0YXJnKT09MCkKQEAgLTgxNCwxMyArODQwLDkgQEANCiAJfQogCXNyYW5kKEdl
dEN1cnJlbnRQcm9jZXNzSWQoKSAqIEdldFRpY2tDb3VudCgpKTsKIAotCS8vVE9ETzogZ2V0IHBh
Z2VzaXplIGZyb20gc3lzaW5mbwotCXBhZ2Vfc2l6ZSA9IDQwOTY7Ci0KLQkvL1RPRE8gIGdldCB0
aGUgZGV2aWNlIG5hbWVzCi0KLQotCWN0eCA9IHBwX2luaXRfY3R4KHNpemUsIGliX3BvcnQsICZ1
c2VyX3BhcmFtKTsKKwlwYWdlX3NpemUgPSBzaS5kd1BhZ2VTaXplOworCQorCWN0eCA9IHBwX2lu
aXRfY3R4KHNpemUsIGliX3BvcnQsICZ1c2VyX3BhcmFtLCBpYl9kZXZndWlkKTsKIAlpZiAoIWN0
eCkKIAkJcmV0dXJuIDg7CiAJc29ja2ZkID0gcHBfb3Blbl9wb3J0KGN0eCwgdXNlcl9wYXJhbS5z
ZXJ2ZXJuYW1lLCBpYl9wb3J0LCBwb3J0LCZteV9kZXN0LCZyZW1fZGVzdCwmdXNlcl9wYXJhbSk7
CkluZGV4OiBEOi9XaW5kb3dzL01MTlhfVlBJL3Rvb2xzL3BlcmZ0ZXN0cy91c2VyL3NlbmRfbGF0
L1NPVVJDRVMNCj09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT0NCi0tLSBEOi9XaW5kb3dzL01MTlhfVlBJL3Rvb2xzL3BlcmZ0
ZXN0cy91c2VyL3NlbmRfbGF0L1NPVVJDRVMJKHJldmlzaW9uIDY1NDUpDQorKysgRDovV2luZG93
cy9NTE5YX1ZQSS90b29scy9wZXJmdGVzdHMvdXNlci9zZW5kX2xhdC9TT1VSQ0VTCShyZXZpc2lv
biA2NTQ2KQ0KQEAgLTExLDcgKzExLDcgQEANCiAJLi5ccGVyZl91dGlscy5jIFwNCiAJc2VuZF9s
YXQuYyANCiANCi1JTkNMVURFUz0uLjsuLlwuLlwuLlwuLlxpbmM7Li5cLi5cLi5cLi5caW5jXHVz
ZXINCitJTkNMVURFUz0uLjsuLlwuLlwuLlwuLlxpbmM7Li5cLi5cLi5cLi5caW5jXHVzZXI7Li5c
Li5cLi5cLi5caHdcbWx4NFx1c2VyXGhjYTsuLlwuLlwuLlwuLlxpbmNcY29tcGxpYg0KIA0KIFJD
T1BUSU9OUz0vSS4uXC4uXHdpblxpbmNsdWRlDQogDQpJbmRleDogRDovV2luZG93cy9NTE5YX1ZQ
SS90b29scy9wZXJmdGVzdHMvdXNlci9zZW5kX2xhdC9zZW5kX2xhdC5jDQo9PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09DQot
LS0gRDovV2luZG93cy9NTE5YX1ZQSS90b29scy9wZXJmdGVzdHMvdXNlci9zZW5kX2xhdC9zZW5k
X2xhdC5jCShyZXZpc2lvbiA2NTQ1KQ0KKysrIEQ6L1dpbmRvd3MvTUxOWF9WUEkvdG9vbHMvcGVy
ZnRlc3RzL3VzZXIvc2VuZF9sYXQvc2VuZF9sYXQuYwkocmV2aXNpb24gNjU0NikNCkBAIC0zOCw2
ICszOCw3IEBADQogI2luY2x1ZGUgImdldG9wdC5oIgogI2luY2x1ZGUgImdldF9jbG9jay5oIgog
I2luY2x1ZGUgInBlcmZfZGVmcy5oIgorI2luY2x1ZGUgImwydy5oIgogCiAKIApAQCAtNjcsMTIg
KzY4LDEzIEBADQogfQogCiAKLXN0YXRpYyBzdHJ1Y3QgcGluZ3BvbmdfY29udGV4dCAqcHBfaW5p
dF9jdHgodW5zaWduZWQgaW50IHNpemUsaW50IHBvcnQsc3RydWN0IHVzZXJfcGFyYW1ldGVycyAq
dXNlcl9wYXJtKSB7CitzdGF0aWMgc3RydWN0IHBpbmdwb25nX2NvbnRleHQgKnBwX2luaXRfY3R4
KHVuc2lnbmVkIGludCBzaXplLGludCBwb3J0LHN0cnVjdCB1c2VyX3BhcmFtZXRlcnMgKnVzZXJf
cGFybSwgY2hhciogaWJfZGV2Z3VpZCkgewogCiAJc3RydWN0IHBpbmdwb25nX2NvbnRleHQJKmN0
eDsKIAlpYl9hcGlfc3RhdHVzX3QgCQkJaWJfc3RhdHVzID0gSUJfU1VDQ0VTUzsJCiAJc2l6ZV90
IAkJCQkJZ3VpZF9jb3VudDsKIAlpYl9uZXQ2NF90CQkJCSpjYV9ndWlkX2FycmF5OworCWludCAJ
CQkJCWd1aWRfaW5kZXggPSAwOwogCiAKIAkKQEAgLTE1Niw3ICsxNTgsMjkgQEANCiAJICogT3Bl
biBvbmx5IHRoZSBmaXJzdCBIQ0EKIAkgKi8KIAkvKiBPcGVuIHRoZSBDQSAqLwotCWliX3N0YXR1
cyA9IGliX29wZW5fY2EoY3R4LT5hbCAsY2FfZ3VpZF9hcnJheVswXSAsTlVMTCwKKwlpZiAoaWJf
ZGV2Z3VpZCkgCisJeworCQl1bnNpZ25lZCBpbnQgaSA9IDA7CisJCWd1aWRfaW5kZXggPSAtMTsK
KwkJZm9yIChpID0gMDsgaSA8IGd1aWRfY291bnQ7IGkrKykKKwkJeworCQkJY2hhciBjdXJyX2Rl
dlsyMF07CisJCQlzcHJpbnRmKGN1cnJfZGV2LCAiMHglMDE2STY0eCIsIG50b2hsbChjYV9ndWlk
X2FycmF5W2ldKSk7CisJCQlpZiAoIV9zdHJpY21wKGliX2Rldmd1aWQsIGN1cnJfZGV2KSkKKwkJ
CXsKKwkJCQlndWlkX2luZGV4ID0gaTsKKwkJCQlicmVhazsKKwkJCX0KKwkJfQorCQlpZiAoZ3Vp
ZF9pbmRleCA9PSAtMSkKKwkJeworCQkJZnByaW50ZihzdGRlcnIsImRldmljZSB3aXRoIGd1aWQg
JXMgd2FzIG5vdCBmb3VuZFxuIiwgaWJfZGV2Z3VpZCk7CisJCQlyZXR1cm4gTlVMTDsKKwkJfQor
CX0KKworCQorCWliX3N0YXR1cyA9IGliX29wZW5fY2EoY3R4LT5hbCAsY2FfZ3VpZF9hcnJheVtn
dWlkX2luZGV4XSAsTlVMTCwKIAkJTlVMTCwJLy9jYV9jb250ZXh0CiAJCSZjdHgtPmNhKTsKIApA
QCAtNTM2LDYgKzU2MCw3IEBADQogCXByaW50ZigiXG4iKTsKIAlwcmludGYoIk9wdGlvbnM6XG4i
KTsKIAlwcmludGYoIiAgLXAsIC0tcG9ydD08cG9ydD4gICAgICAgICAgICBsaXN0ZW4gb24vY29u
bmVjdCB0byBwb3J0IDxwb3J0PiAoZGVmYXVsdCAxODUxNSlcbiIpOworCXByaW50ZigiICAtZCwg
LS1pYi1kZXY9PGRldj4gICAgICAgICAgIHVzZSBJQiBkZXZpY2UgPGRldmljZSBndWlkPiAoZGVm
YXVsdCBmaXJzdCBkZXZpY2UgZm91bmQpXG4iKTsKIAlwcmludGYoIiAgLWMsIC0tY29ubmVjdGlv
bj08UkMvVUM+ICAgICBjb25uZWN0aW9uIHR5cGUgUkMvVUMgKGRlZmF1bHQgUkMpXG4iKTsKIAlw
cmludGYoIiAgLW0sIC0tbXR1PTxtdHU+ICAgICAgICAgICAgICBtdHUgc2l6ZSAoZGVmYXVsdCAy
MDQ4KVxuIik7CiAJcHJpbnRmKCIgIC1pLCAtLWliLXBvcnQ9PHBvcnQ+ICAgICAgICAgdXNlIHBv
cnQgPHBvcnQ+IG9mIElCIGRldmljZSAoZGVmYXVsdCAxKVxuIik7CkBAIC03OTMsNyArODE4LDcg
QEANCiAJc3RydWN0IHBpbmdwb25nX2Rlc3QgICAgICpteV9kZXN0OwogCXN0cnVjdCBwaW5ncG9u
Z19kZXN0ICAgICAqcmVtX2Rlc3Q7CiAJc3RydWN0IHVzZXJfcGFyYW1ldGVycyAgdXNlcl9wYXJh
bTsKLQljaGFyCQkJCSppYl9kZXZuYW1lID0gTlVMTDsKKwljaGFyCQkJCSppYl9kZXZndWlkID0g
TlVMTDsKIAlpbnQJCQkJcG9ydCA9IDE4NTE1OwogCWludAkJCQlpYl9wb3J0ID0gMTsKIAl1bnNp
Z25lZAkJCXNpemUgPSAyOwpAQCAtODA2LDYgKzgzMSw5IEBADQogCiAJc3RydWN0IHJlcG9ydF9v
cHRpb25zICAgIHJlcG9ydCA9IHswfTsKIAorCVNZU1RFTV9JTkZPIHNpOworCUdldFN5c3RlbUlu
Zm8oJnNpKTsKKwogCS8qIGluaXQgZGVmYXVsdCB2YWx1ZXMgdG8gdXNlcidzIHBhcmFtZXRlcnMg
Ki8KIAltZW1zZXQoJnVzZXJfcGFyYW0sIDAsIHNpemVvZihzdHJ1Y3QgdXNlcl9wYXJhbWV0ZXJz
KSk7CiAJdXNlcl9wYXJhbS5tdHUgPSAwOwpAQCAtODY3LDcgKzg5NSw3IEBADQogCQkJcmV0dXJu
IDA7CiAJCQlicmVhazsKIAkJY2FzZSAnZCc6Ci0JCQlpYl9kZXZuYW1lID0gX3N0cmR1cChvcHRh
cmcpOworCQkJaWJfZGV2Z3VpZCA9IF9zdHJkdXAob3B0YXJnKTsKIAkJCWJyZWFrOwogCiAJCWNh
c2UgJ2knOgpAQCAtOTY3LDEyICs5OTUsOSBAQA0KIAkKIAlzcmFuZChHZXRDdXJyZW50UHJvY2Vz
c0lkKCkgKiBHZXRUaWNrQ291bnQoKSk7CiAKLQkvL1RPRE86IGdldCBwYWdlc2l6ZSBmcm9tIHN5
c2luZm8KLQlwYWdlX3NpemUgPSA0MDk2OwotCi0JLy9UT0RPICBnZXQgdGhlIGRldmljZSBuYW1l
cworCXBhZ2Vfc2l6ZSA9IHNpLmR3UGFnZVNpemU7CiAJCi0JY3R4ID0gcHBfaW5pdF9jdHgoIHNp
emUsIGliX3BvcnQsJnVzZXJfcGFyYW0pOworCWN0eCA9IHBwX2luaXRfY3R4KCBzaXplLCBpYl9w
b3J0LCZ1c2VyX3BhcmFtLCBpYl9kZXZndWlkKTsKIAlpZiAoIWN0eCkKIAkJcmV0dXJuIDg7CiAK
SW5kZXg6IEQ6L1dpbmRvd3MvTUxOWF9WUEkvdG9vbHMvcGVyZnRlc3RzL3VzZXIvd3JpdGVfbGF0
L1NPVVJDRVMNCj09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT0NCi0tLSBEOi9XaW5kb3dzL01MTlhfVlBJL3Rvb2xzL3BlcmZ0
ZXN0cy91c2VyL3dyaXRlX2xhdC9TT1VSQ0VTCShyZXZpc2lvbiA2NTQ1KQ0KKysrIEQ6L1dpbmRv
d3MvTUxOWF9WUEkvdG9vbHMvcGVyZnRlc3RzL3VzZXIvd3JpdGVfbGF0L1NPVVJDRVMJKHJldmlz
aW9uIDY1NDYpDQpAQCAtMTEsNyArMTEsNyBAQA0KIAkuLlxwZXJmX3V0aWxzLmMgXA0KIAl3cml0
ZV9sYXQuYyANCiANCi1JTkNMVURFUz0uLjsuLlwuLlwuLlwuLlxpbmM7Li5cLi5cLi5cLi5caW5j
XHVzZXINCitJTkNMVURFUz0uLjsuLlwuLlwuLlwuLlxpbmM7Li5cLi5cLi5cLi5caW5jXHVzZXI7
Li5cLi5cLi5cLi5caHdcbWx4NFx1c2VyXGhjYTsuLlwuLlwuLlwuLlxpbmNcY29tcGxpYg0KIA0K
IFJDT1BUSU9OUz0vSS4uXC4uXHdpblxpbmNsdWRlDQogDQpJbmRleDogRDovV2luZG93cy9NTE5Y
X1ZQSS90b29scy9wZXJmdGVzdHMvdXNlci93cml0ZV9sYXQvd3JpdGVfbGF0LmMNCj09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT0NCi0tLSBEOi9XaW5kb3dzL01MTlhfVlBJL3Rvb2xzL3BlcmZ0ZXN0cy91c2VyL3dyaXRlX2xh
dC93cml0ZV9sYXQuYwkocmV2aXNpb24gNjU0NSkNCisrKyBEOi9XaW5kb3dzL01MTlhfVlBJL3Rv
b2xzL3BlcmZ0ZXN0cy91c2VyL3dyaXRlX2xhdC93cml0ZV9sYXQuYwkocmV2aXNpb24gNjU0NikN
CkBAIC0zOCw2ICszOCw3IEBADQogI2luY2x1ZGUgImdldG9wdC5oIgogI2luY2x1ZGUgInBlcmZf
ZGVmcy5oIgogI2luY2x1ZGUgImdldF9jbG9jay5oIgorI2luY2x1ZGUgImwydy5oIgogCiAKIApA
QCAtNjgsNyArNjksNyBAQA0KIH0KIAogCi1zdGF0aWMgc3RydWN0IHBpbmdwb25nX2NvbnRleHQg
KnBwX2luaXRfY3R4KHVuc2lnbmVkIHNpemUsIGludCBwb3J0LCBzdHJ1Y3QgdXNlcl9wYXJhbWV0
ZXJzICp1c2VyX3Bhcm0pCitzdGF0aWMgc3RydWN0IHBpbmdwb25nX2NvbnRleHQgKnBwX2luaXRf
Y3R4KHVuc2lnbmVkIHNpemUsIGludCBwb3J0LCBzdHJ1Y3QgdXNlcl9wYXJhbWV0ZXJzICp1c2Vy
X3Bhcm0sIGNoYXIqIGliX2Rldmd1aWQpCiB7CiAKIApAQCAtNzYsNiArNzcsNyBAQA0KIAlpYl9h
cGlfc3RhdHVzX3QgCQkJaWJfc3RhdHVzID0gSUJfU1VDQ0VTUzsJCiAJc2l6ZV90IAkJCQkJZ3Vp
ZF9jb3VudDsKIAlpYl9uZXQ2NF90CQkJCSpjYV9ndWlkX2FycmF5OworCWludAkJCQkJCWd1aWRf
aW5kZXggPSAwOwogCiAJY3R4ID0gbWFsbG9jKHNpemVvZiAqY3R4KTsKIAlpZiAoIWN0eCl7CkBA
IC0xNTAsNyArMTUyLDI4IEBADQogCSAqIE9wZW4gb25seSB0aGUgZmlyc3QgSENBCiAJICovCiAJ
LyogT3BlbiB0aGUgQ0EgKi8KLQlpYl9zdGF0dXMgPSBpYl9vcGVuX2NhKGN0eC0+YWwgLGNhX2d1
aWRfYXJyYXlbMF0gLE5VTEwsCisJaWYgKGliX2Rldmd1aWQpIAorCXsKKwkJdW5zaWduZWQgaW50
IGkgPSAwOworCQlndWlkX2luZGV4ID0gLTE7CisJCWZvciAoaSA9IDA7IGkgPCBndWlkX2NvdW50
OyBpKyspCisJCXsKKwkJCWNoYXIgY3Vycl9kZXZbMjBdOworCQkJc3ByaW50ZihjdXJyX2Rldiwg
IjB4JTAxNkk2NHgiLCBudG9obGwoY2FfZ3VpZF9hcnJheVtpXSkpOworCQkJaWYgKCFfc3RyaWNt
cChpYl9kZXZndWlkLCBjdXJyX2RldikpCisJCQl7CisJCQkJZ3VpZF9pbmRleCA9IGk7CisJCQkJ
YnJlYWs7CisJCQl9CisJCX0KKwkJaWYgKGd1aWRfaW5kZXggPT0gLTEpCisJCXsKKwkJCWZwcmlu
dGYoc3RkZXJyLCJkZXZpY2Ugd2l0aCBndWlkICVzIHdhcyBub3QgZm91bmRcbiIsIGliX2Rldmd1
aWQpOworCQkJcmV0dXJuIE5VTEw7CisJCX0KKwl9CisJCisJaWJfc3RhdHVzID0gaWJfb3Blbl9j
YShjdHgtPmFsICxjYV9ndWlkX2FycmF5W2d1aWRfaW5kZXhdICxOVUxMLAogCQlOVUxMLAkvL2Nh
X2NvbnRleHQKIAkJJmN0eC0+Y2EpOwogCkBAIC00NjUsNiArNDg4LDcgQEANCiAJcHJpbnRmKCJc
biIpOwogCXByaW50ZigiT3B0aW9uczpcbiIpOwogCXByaW50ZigiICAtcCwgLS1wb3J0PTxwb3J0
PiAgICAgICAgICAgIGxpc3RlbiBvbi9jb25uZWN0IHRvIHBvcnQgPHBvcnQ+IChkZWZhdWx0IDE4
NTE1KVxuIik7CisJcHJpbnRmKCIgIC1kLCAtLWliLWRldj08ZGV2PiAgICAgICAgdXNlIElCIGRl
dmljZSA8ZGV2aWNlIGd1aWQ+IChkZWZhdWx0IGZpcnN0IGRldmljZSBmb3VuZClcbiIpOwogCXBy
aW50ZigiICAtYywgLS1jb25uZWN0aW9uPTxSQy9VQz4gICAgIGNvbm5lY3Rpb24gdHlwZSBSQy9V
QyAoZGVmYXVsdCBSQylcbiIpOwogCXByaW50ZigiICAtbSwgLS1tdHU9PG10dT4gICAgICAgICAg
ICAgIG10dSBzaXplIChkZWZhdWx0IDEwMjQpXG4iKTsKIAlwcmludGYoIiAgLWksIC0taWItcG9y
dD08cG9ydD4gICAgICAgICB1c2UgcG9ydCA8cG9ydD4gb2YgSUIgZGV2aWNlIChkZWZhdWx0IDEp
XG4iKTsKQEAgLTY0Nyw3ICs2NzEsNyBAQA0KIAlzdHJ1Y3QgcGluZ3BvbmdfZGVzdCAgICAgKm15
X2Rlc3Q7CiAJc3RydWN0IHBpbmdwb25nX2Rlc3QgICAgICpyZW1fZGVzdDsKIAlzdHJ1Y3QgdXNl
cl9wYXJhbWV0ZXJzICB1c2VyX3BhcmFtOwotCWNoYXIJCQkJKmliX2Rldm5hbWUgPSBOVUxMOwor
CWNoYXIJCQkJKmliX2Rldmd1aWQgPSBOVUxMOwogCWludAkJCQlwb3J0ID0gMTg1MTU7CiAJaW50
CQkJCWliX3BvcnQgPSAxOwogCXVuc2lnbmVkCQkJc2l6ZSA9IDI7CkBAIC02NTcsNiArNjgxLDgg
QEANCiAJaW50CQkJCWlSZXN1bHQ7IAogCXN0cnVjdCByZXBvcnRfb3B0aW9ucyAgICByZXBvcnQg
PSB7MH07CiAKKwlTWVNURU1fSU5GTyBzaTsKKwlHZXRTeXN0ZW1JbmZvKCZzaSk7CiAKIAkvKiBp
bml0IGRlZmF1bHQgdmFsdWVzIHRvIHVzZXIncyBwYXJhbWV0ZXJzICovCiAJbWVtc2V0KCZ1c2Vy
X3BhcmFtLCAwLCBzaXplb2Yoc3RydWN0IHVzZXJfcGFyYW1ldGVycykpOwpAQCAtNzE1LDcgKzc0
MSw3IEBADQogCQkJcmV0dXJuIDA7CiAJCQlicmVhazsKIAkJY2FzZSAnZCc6Ci0JCQlpYl9kZXZu
YW1lID0gX3N0cmR1cChvcHRhcmcpOworCQkJaWJfZGV2Z3VpZCA9IF9zdHJkdXAob3B0YXJnKTsK
IAkJCWJyZWFrOwogCiAJCWNhc2UgJ2knOgpAQCAtODExLDEzICs4MzcsOSBAQA0KIAl9CiAJc3Jh
bmQoR2V0Q3VycmVudFByb2Nlc3NJZCgpICogR2V0VGlja0NvdW50KCkpOwogCi0JLy9UT0RPOiBn
ZXQgcGFnZXNpemUgZnJvbSBzeXNpbmZvCi0JcGFnZV9zaXplID0gNDA5NjsKKwlwYWdlX3NpemUg
PSBzaS5kd1BhZ2VTaXplOwogCi0JLy9UT0RPICBnZXQgdGhlIGRldmljZSBuYW1lcwotCQotCi0J
Y3R4ID0gcHBfaW5pdF9jdHgoIHNpemUsIGliX3BvcnQsJnVzZXJfcGFyYW0pOworCWN0eCA9IHBw
X2luaXRfY3R4KCBzaXplLCBpYl9wb3J0LCZ1c2VyX3BhcmFtLCBpYl9kZXZndWlkKTsKIAlpZiAo
IWN0eCkKIAkJcmV0dXJuIDg7CiAJc29ja2ZkID0gcHBfb3Blbl9wb3J0KGN0eCwgdXNlcl9wYXJh
bS5zZXJ2ZXJuYW1lLCBpYl9wb3J0LCBwb3J0LCZteV9kZXN0LCZyZW1fZGVzdCwmdXNlcl9wYXJh
bSk7CkBAIC04NDYsNCArODY4LDQgQEANCiAJcHJpbnRmKCItLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS1cbiIpOwogCWZyZWUo
dHN0YW1wKTsKIAlyZXR1cm4gMDsKLX0KK30NClwgTm8gbmV3bGluZSBhdCBlbmQgb2YgZmlsZQ0K
SW5kZXg6IEQ6L1dpbmRvd3MvTUxOWF9WUEkvdG9vbHMvcGVyZnRlc3RzL3VzZXIvcmVhZF9idy9T
T1VSQ0VTDQo9PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09DQotLS0gRDovV2luZG93cy9NTE5YX1ZQSS90b29scy9wZXJmdGVz
dHMvdXNlci9yZWFkX2J3L1NPVVJDRVMJKHJldmlzaW9uIDY1NDUpDQorKysgRDovV2luZG93cy9N
TE5YX1ZQSS90b29scy9wZXJmdGVzdHMvdXNlci9yZWFkX2J3L1NPVVJDRVMJKHJldmlzaW9uIDY1
NDYpDQpAQCAtMTEsNyArMTEsNyBAQA0KIAkuLlxwZXJmX3V0aWxzLmMgXA0KIAlyZWFkX2J3LmMg
DQogDQotSU5DTFVERVM9Li47Li5cLi5cLi5cLi5caW5jOy4uXC4uXC4uXC4uXGluY1x1c2VyDQor
SU5DTFVERVM9Li47Li5cLi5cLi5cLi5caW5jOy4uXC4uXC4uXC4uXGluY1x1c2VyOy4uXC4uXC4u
XC4uXGh3XG1seDRcdXNlclxoY2E7Li5cLi5cLi5cLi5caW5jXGNvbXBsaWINCiANCiBSQ09QVElP
TlM9L0kuLlwuLlx3aW5caW5jbHVkZQ0KIA0KSW5kZXg6IEQ6L1dpbmRvd3MvTUxOWF9WUEkvdG9v
bHMvcGVyZnRlc3RzL3VzZXIvcmVhZF9idy9yZWFkX2J3LmMNCj09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT0NCi0tLSBEOi9X
aW5kb3dzL01MTlhfVlBJL3Rvb2xzL3BlcmZ0ZXN0cy91c2VyL3JlYWRfYncvcmVhZF9idy5jCShy
ZXZpc2lvbiA2NTQ1KQ0KKysrIEQ6L1dpbmRvd3MvTUxOWF9WUEkvdG9vbHMvcGVyZnRlc3RzL3Vz
ZXIvcmVhZF9idy9yZWFkX2J3LmMJKHJldmlzaW9uIDY1NDYpDQpAQCAtMzcsNiArMzcsNyBAQA0K
ICNpbmNsdWRlICJnZXRvcHQuaCIKICNpbmNsdWRlICJwZXJmX2RlZnMuaCIKICNpbmNsdWRlICJn
ZXRfY2xvY2suaCIKKyNpbmNsdWRlICJsMncuaCIKIAogc3RydWN0IHVzZXJfcGFyYW1ldGVycyB7
CiAJY29uc3QgY2hhciAgICAgICAgICAgICAgKnNlcnZlcm5hbWU7CkBAIC02NCwxMyArNjUsMTQg
QEANCiAJcmV0dXJuIDsKIH0KIAotc3RhdGljIHN0cnVjdCBwaW5ncG9uZ19jb250ZXh0ICpwcF9p
bml0X2N0eCh1bnNpZ25lZCBzaXplLGludCBwb3J0LCBzdHJ1Y3QgdXNlcl9wYXJhbWV0ZXJzICp1
c2VyX3Bhcm0pCitzdGF0aWMgc3RydWN0IHBpbmdwb25nX2NvbnRleHQgKnBwX2luaXRfY3R4KHVu
c2lnbmVkIHNpemUsaW50IHBvcnQsIHN0cnVjdCB1c2VyX3BhcmFtZXRlcnMgKnVzZXJfcGFybSwg
Y2hhciogaWJfZGV2Z3VpZCkKIHsKIAogCXN0cnVjdCBwaW5ncG9uZ19jb250ZXh0CSpjdHg7CiAJ
aWJfYXBpX3N0YXR1c190IAkJCWliX3N0YXR1cyA9IElCX1NVQ0NFU1M7CQogCXNpemVfdCAJCQkJ
CWd1aWRfY291bnQ7CiAJaWJfbmV0NjRfdAkJCQkqY2FfZ3VpZF9hcnJheTsKKwlpbnQgCQkJCQln
dWlkX2luZGV4ID0gMDsKIAogCiAJY3R4ID0gbWFsbG9jKHNpemVvZiAqY3R4KTsKQEAgLTE0NSw3
ICsxNDcsMjggQEANCiAJICogT3BlbiBvbmx5IHRoZSBmaXJzdCBIQ0EKIAkgKi8KIAkvKiBPcGVu
IHRoZSBDQSAqLwotCWliX3N0YXR1cyA9IGliX29wZW5fY2EoY3R4LT5hbCAsY2FfZ3VpZF9hcnJh
eVswXSAsTlVMTCwKKwlpZiAoaWJfZGV2Z3VpZCkgCisJeworCQl1bnNpZ25lZCBpbnQgaSA9IDA7
CisJCWd1aWRfaW5kZXggPSAtMTsKKwkJZm9yIChpID0gMDsgaSA8IGd1aWRfY291bnQ7IGkrKykK
KwkJeworCQkJY2hhciBjdXJyX2RldlsyMF07CisJCQlzcHJpbnRmKGN1cnJfZGV2LCAiMHglMDE2
STY0eCIsIG50b2hsbChjYV9ndWlkX2FycmF5W2ldKSk7CisJCQlpZiAoIV9zdHJpY21wKGliX2Rl
dmd1aWQsIGN1cnJfZGV2KSkKKwkJCXsKKwkJCQlndWlkX2luZGV4ID0gaTsKKwkJCQlicmVhazsK
KwkJCX0KKwkJfQorCQlpZiAoZ3VpZF9pbmRleCA9PSAtMSkKKwkJeworCQkJZnByaW50ZihzdGRl
cnIsImRldmljZSB3aXRoIGd1aWQgJXMgd2FzIG5vdCBmb3VuZFxuIiwgaWJfZGV2Z3VpZCk7CisJ
CQlyZXR1cm4gTlVMTDsKKwkJfQorCX0KKwkKKwlpYl9zdGF0dXMgPSBpYl9vcGVuX2NhKGN0eC0+
YWwgLGNhX2d1aWRfYXJyYXlbZ3VpZF9pbmRleF0gLE5VTEwsCiAJCU5VTEwsCS8vY2FfY29udGV4
dAogCQkmY3R4LT5jYSk7CiAKQEAgLTQ0NSw2ICs0NjgsNyBAQA0KIAlwcmludGYoIlxuIik7CiAJ
cHJpbnRmKCJPcHRpb25zOlxuIik7CiAJcHJpbnRmKCIgIC1wLCAtLXBvcnQ9PHBvcnQ+ICAgICAg
bGlzdGVuIG9uL2Nvbm5lY3QgdG8gcG9ydCA8cG9ydD4gKGRlZmF1bHQgMTg1MTUpXG4iKTsKKwlw
cmludGYoIiAgLWQsIC0taWItZGV2PTxkZXY+ICAgICAgICB1c2UgSUIgZGV2aWNlIDxkZXZpY2Ug
Z3VpZD4gKGRlZmF1bHQgZmlyc3QgZGV2aWNlIGZvdW5kKVxuIik7CiAJcHJpbnRmKCIgIC1pLCAt
LWliLXBvcnQ9PHBvcnQ+ICAgdXNlIHBvcnQgPHBvcnQ+IG9mIElCIGRldmljZSAoZGVmYXVsdCAx
KVxuIik7CiAJcHJpbnRmKCIgIC1tLCAtLW10dT08bXR1PiAgICAgICAgbXR1IHNpemUgKGRlZmF1
bHQgMTAyNClcbiIpOwogCXByaW50ZigiICAtbywgLS1vdXRzPTxudW0+ICAgICAgIG51bSBvZiBv
dXRzdGFuZGluZyByZWFkL2F0b20oZGVmYXVsdCA0KVxuIik7CkBAIC01ODIsNyArNjA2LDcgQEAN
CiAJc3RydWN0IHBpbmdwb25nX2Rlc3QgICAgICpteV9kZXN0OwogCXN0cnVjdCBwaW5ncG9uZ19k
ZXN0ICAgICAqcmVtX2Rlc3Q7CiAJc3RydWN0IHVzZXJfcGFyYW1ldGVycyAgdXNlcl9wYXJhbTsK
LQljaGFyCQkJCSppYl9kZXZuYW1lID0gTlVMTDsKKwljaGFyCQkJCSppYl9kZXZndWlkID0gTlVM
TDsKIAlpbnQJCQkJcG9ydCA9IDE4NTE1OwogCWludAkJCQlpYl9wb3J0ID0gMTsKIAl1bnNpZ25l
ZAkJCXNpemUgPSA2NTUzNjsKQEAgLTU5Miw2ICs2MTYsOSBAQA0KIAlpbnQJCQkJaSA9IDA7CiAJ
aW50CQkJCWR1cGxleCA9IDA7CiAKKwlTWVNURU1fSU5GTyBzaTsKKwlHZXRTeXN0ZW1JbmZvKCZz
aSk7CisKIAkvKiBpbml0IGRlZmF1bHQgdmFsdWVzIHRvIHVzZXIncyBwYXJhbWV0ZXJzICovCiAJ
bWVtc2V0KCZ1c2VyX3BhcmFtLCAwLCBzaXplb2Yoc3RydWN0IHVzZXJfcGFyYW1ldGVycykpOwog
CXVzZXJfcGFyYW0ubXR1ID0gMDsgLyogc2lnbmFsIGNob29zZSBkZWZhdWx0IGJ5IGRldmljZSAq
LwpAQCAtNjMyLDcgKzY1OSw3IEBADQogCQkJYnJlYWs7CiAKIAkJY2FzZSAnZCc6Ci0JCQlpYl9k
ZXZuYW1lID0gX3N0cmR1cChvcHRhcmcpOworCQkJaWJfZGV2Z3VpZCA9IF9zdHJkdXAob3B0YXJn
KTsKIAkJCWJyZWFrOwogCQljYXNlICdtJzoKIAkJCXVzZXJfcGFyYW0ubXR1ID0gc3RydG9sKG9w
dGFyZywgTlVMTCwgMCk7CkBAIC03MTcsMTMgKzc0NCw5IEBADQogCQogCXNyYW5kKEdldEN1cnJl
bnRQcm9jZXNzSWQoKSAqIEdldFRpY2tDb3VudCgpKTsKIAotCS8vVE9ETzogZ2V0IHBhZ2VzaXpl
IGZyb20gc3lzaW5mbwotCXBhZ2Vfc2l6ZSA9IDQwOTY7CisJcGFnZV9zaXplID0gc2kuZHdQYWdl
U2l6ZTsKIAotCS8vVE9ETzpnZXQgdGhlIGRldmljZSBuYW1lcwotCi0KLQljdHggPSBwcF9pbml0
X2N0eChzaXplLGliX3BvcnQsICZ1c2VyX3BhcmFtKTsKKwljdHggPSBwcF9pbml0X2N0eChzaXpl
LGliX3BvcnQsICZ1c2VyX3BhcmFtLCBpYl9kZXZndWlkKTsKIAlpZiAoIWN0eCkKIAkJcmV0dXJu
IDg7CiAKSW5kZXg6IEQ6L1dpbmRvd3MvTUxOWF9WUEkvdG9vbHMvcGVyZnRlc3RzL3VzZXIvcmVh
ZF9sYXQvU09VUkNFUw0KPT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PQ0KLS0tIEQ6L1dpbmRvd3MvTUxOWF9WUEkvdG9vbHMv
cGVyZnRlc3RzL3VzZXIvcmVhZF9sYXQvU09VUkNFUwkocmV2aXNpb24gNjU0NSkNCisrKyBEOi9X
aW5kb3dzL01MTlhfVlBJL3Rvb2xzL3BlcmZ0ZXN0cy91c2VyL3JlYWRfbGF0L1NPVVJDRVMJKHJl
dmlzaW9uIDY1NDYpDQpAQCAtMTEsNyArMTEsNyBAQA0KIAkuLlxwZXJmX3V0aWxzLmMgXA0KIAly
ZWFkX2xhdC5jIA0KIA0KLUlOQ0xVREVTPS4uOy4uXC4uXC4uXC4uXGluYzsuLlwuLlwuLlwuLlxp
bmNcdXNlcg0KK0lOQ0xVREVTPS4uOy4uXC4uXC4uXC4uXGluYzsuLlwuLlwuLlwuLlxpbmNcdXNl
cjsuLlwuLlwuLlwuLlxod1xtbHg0XHVzZXJcaGNhOy4uXC4uXC4uXC4uXGluY1xjb21wbGliDQog
DQogUkNPUFRJT05TPS9JLi5cLi5cd2luXGluY2x1ZGUNCiANCkluZGV4OiBEOi9XaW5kb3dzL01M
TlhfVlBJL3Rvb2xzL3BlcmZ0ZXN0cy91c2VyL3JlYWRfbGF0L3JlYWRfbGF0LmMNCj09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT0NCi0tLSBEOi9XaW5kb3dzL01MTlhfVlBJL3Rvb2xzL3BlcmZ0ZXN0cy91c2VyL3JlYWRfbGF0
L3JlYWRfbGF0LmMJKHJldmlzaW9uIDY1NDUpDQorKysgRDovV2luZG93cy9NTE5YX1ZQSS90b29s
cy9wZXJmdGVzdHMvdXNlci9yZWFkX2xhdC9yZWFkX2xhdC5jCShyZXZpc2lvbiA2NTQ2KQ0KQEAg
LTM4LDYgKzM4LDcgQEANCiAjaW5jbHVkZSAiZ2V0b3B0LmgiCiAjaW5jbHVkZSAicGVyZl9kZWZz
LmgiCiAjaW5jbHVkZSAiZ2V0X2Nsb2NrLmgiCisjaW5jbHVkZSAibDJ3LmgiCiAKIAogCkBAIC02
OCw3ICs2OSw3IEBADQogCXJldHVybiA7CiB9CiAKLXN0YXRpYyBzdHJ1Y3QgcGluZ3BvbmdfY29u
dGV4dCAqcHBfaW5pdF9jdHgodW5zaWduZWQgc2l6ZSxpbnQgcG9ydCwgc3RydWN0IHVzZXJfcGFy
YW1ldGVycyAqdXNlcl9wYXJtKQorc3RhdGljIHN0cnVjdCBwaW5ncG9uZ19jb250ZXh0ICpwcF9p
bml0X2N0eCh1bnNpZ25lZCBzaXplLGludCBwb3J0LCBzdHJ1Y3QgdXNlcl9wYXJhbWV0ZXJzICp1
c2VyX3Bhcm0sIGNoYXIqIGliX2Rldmd1aWQpCiB7CiAKIApAQCAtNzYsNiArNzcsNyBAQA0KIAlp
Yl9hcGlfc3RhdHVzX3QgCQkJaWJfc3RhdHVzID0gSUJfU1VDQ0VTUzsJCiAJc2l6ZV90IAkJCQkJ
Z3VpZF9jb3VudDsKIAlpYl9uZXQ2NF90CQkJCSpjYV9ndWlkX2FycmF5OworCWludAkJCQkJCWd1
aWRfaW5kZXggPSAwOwogCiAKIAljdHggPSBtYWxsb2Moc2l6ZW9mICpjdHgpOwpAQCAtMTQ5LDcg
KzE1MSwyOCBAQA0KIAkgKiBPcGVuIG9ubHkgdGhlIGZpcnN0IEhDQQogCSAqLwogCS8qIE9wZW4g
dGhlIENBICovCi0JaWJfc3RhdHVzID0gaWJfb3Blbl9jYShjdHgtPmFsICxjYV9ndWlkX2FycmF5
WzBdICxOVUxMLAorCWlmIChpYl9kZXZndWlkKSAKKwl7CisJCXVuc2lnbmVkIGludCBpID0gMDsK
KwkJZ3VpZF9pbmRleCA9IC0xOworCQlmb3IgKGkgPSAwOyBpIDwgZ3VpZF9jb3VudDsgaSsrKQor
CQl7CisJCQljaGFyIGN1cnJfZGV2WzIwXTsKKwkJCXNwcmludGYoY3Vycl9kZXYsICIweCUwMTZJ
NjR4IiwgbnRvaGxsKGNhX2d1aWRfYXJyYXlbaV0pKTsKKwkJCWlmICghX3N0cmljbXAoaWJfZGV2
Z3VpZCwgY3Vycl9kZXYpKQorCQkJeworCQkJCWd1aWRfaW5kZXggPSBpOworCQkJCWJyZWFrOwor
CQkJfQorCQl9CisJCWlmIChndWlkX2luZGV4ID09IC0xKQorCQl7CisJCQlmcHJpbnRmKHN0ZGVy
ciwiZGV2aWNlIHdpdGggZ3VpZCAlcyB3YXMgbm90IGZvdW5kXG4iLCBpYl9kZXZndWlkKTsKKwkJ
CXJldHVybiBOVUxMOworCQl9CisJfQorCQorCWliX3N0YXR1cyA9IGliX29wZW5fY2EoY3R4LT5h
bCAsY2FfZ3VpZF9hcnJheVtndWlkX2luZGV4XSAsTlVMTCwKIAkJTlVMTCwJLy9jYV9jb250ZXh0
CiAJCSZjdHgtPmNhKTsKIApAQCAtNDU2LDYgKzQ3OSw3IEBADQogCXByaW50ZigiXG4iKTsKIAlw
cmludGYoIk9wdGlvbnM6XG4iKTsKIAlwcmludGYoIiAgLXAsIC0tcG9ydD08cG9ydD4gICAgICAg
ICAgICBsaXN0ZW4gb24vY29ubmVjdCB0byBwb3J0IDxwb3J0PiAoZGVmYXVsdCAxODUxNSlcbiIp
OworCXByaW50ZigiICAtZCwgLS1pYi1kZXY9PGRldj4gICAgICAgICAgIHVzZSBJQiBkZXZpY2Ug
PGRldmljZSBndWlkPiAoZGVmYXVsdCBmaXJzdCBkZXZpY2UgZm91bmQpXG4iKTsKIAlwcmludGYo
IiAgLW0sIC0tbXR1PTxtdHU+ICAgICAgICAgICAgICBtdHUgc2l6ZSAoZGVmYXVsdCAyNTYpXG4i
KTsKIAlwcmludGYoIiAgLWksIC0taWItcG9ydD08cG9ydD4gICAgICAgICB1c2UgcG9ydCA8cG9y
dD4gb2YgSUIgZGV2aWNlIChkZWZhdWx0IDEpXG4iKTsKIAlwcmludGYoIiAgLXMsIC0tc2l6ZT08
c2l6ZT4gICAgICAgICAgICBzaXplIG9mIG1lc3NhZ2UgdG8gZXhjaGFuZ2UgKGRlZmF1bHQgMSlc
biIpOwpAQCAtNTk4LDcgKzYyMiw3IEBADQogCXN0cnVjdCBwaW5ncG9uZ19kZXN0ICAgICAqbXlf
ZGVzdDsKIAlzdHJ1Y3QgcGluZ3BvbmdfZGVzdCAgICAgKnJlbV9kZXN0OwogCXN0cnVjdCB1c2Vy
X3BhcmFtZXRlcnMgIHVzZXJfcGFyYW07Ci0JY2hhcgkJCQkqaWJfZGV2bmFtZSA9IE5VTEw7CisJ
Y2hhcgkJCQkqaWJfZGV2Z3VpZCA9IE5VTEw7CiAJaW50CQkJCXBvcnQgPSAxODUxNTsKIAlpbnQJ
CQkJaWJfcG9ydCA9IDE7CiAJdW5zaWduZWQJCQl0bXBfc2l6ZSxzaXplID0gMjsKQEAgLTYwOCw2
ICs2MzIsOCBAQA0KIAlpbnQJCQkJaSA9IDA7CiAJc3RydWN0IHJlcG9ydF9vcHRpb25zICAgIHJl
cG9ydCA9IHswfTsKIAorCVNZU1RFTV9JTkZPIHNpOworCUdldFN5c3RlbUluZm8oJnNpKTsKIAog
CS8qIGluaXQgZGVmYXVsdCB2YWx1ZXMgdG8gdXNlcidzIHBhcmFtZXRlcnMgKi8KIAltZW1zZXQo
JnVzZXJfcGFyYW0sIDAsIHNpemVvZihzdHJ1Y3QgdXNlcl9wYXJhbWV0ZXJzKSk7CkBAIC02NjUs
NyArNjkxLDcgQEANCiAJCQlyZXR1cm4gMDsKIAkJCWJyZWFrOwogCQljYXNlICdkJzoKLQkJCWli
X2Rldm5hbWUgPSBfc3RyZHVwKG9wdGFyZyk7CisJCQlpYl9kZXZndWlkID0gX3N0cmR1cChvcHRh
cmcpOwogCQkJYnJlYWs7CiAKIAkJY2FzZSAnaSc6CkBAIC03NTUsMTMgKzc4MSw5IEBADQogCQog
CXNyYW5kKEdldEN1cnJlbnRQcm9jZXNzSWQoKSAqIEdldFRpY2tDb3VudCgpKTsKIAotCS8vVE9E
TzogZ2V0IHBhZ2VzaXplIGZyb20gc3lzaW5mbwotCXBhZ2Vfc2l6ZSA9IDQwOTY7CisJcGFnZV9z
aXplID0gc2kuZHdQYWdlU2l6ZTsKIAotCS8vVE9ETzpnZXQgdGhlIGRldmljZSBuYW1lcwotCi0K
LQljdHggPSBwcF9pbml0X2N0eChzaXplLGliX3BvcnQsICZ1c2VyX3BhcmFtKTsKKwljdHggPSBw
cF9pbml0X2N0eChzaXplLGliX3BvcnQsICZ1c2VyX3BhcmFtLCBpYl9kZXZndWlkKTsKIAlpZiAo
IWN0eCkKIAkJcmV0dXJuIDg7CiAK

--_004_E113D394D7C5DB4F8FF691FA7EE9DB443BF12865D0MTLMAILmtlcom_
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
ofw mailing list
ofw@lists.openfabrics.org
http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ofw
--_004_E113D394D7C5DB4F8FF691FA7EE9DB443BF12865D0MTLMAILmtlcom_--
