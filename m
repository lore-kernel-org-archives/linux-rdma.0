From: "Sean Hefty" <sean.hefty@intel.com>
Subject: RE: [PATCH 1/2] contain pthreads defs with ifdef
	HAVE_LIBPTHREAD
Date: Wed, 4 Nov 2009 13:05:13 -0800
Message-ID: <74DB7ADB8B154DE69B8F65456193D483@amr.corp.intel.com>
References: <F9EFFFF3BD1D442AB6AA993FD6F0B5D8@amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <ofw-bounces@lists.openfabrics.org>
In-Reply-To: <F9EFFFF3BD1D442AB6AA993FD6F0B5D8@amr.corp.intel.com>
List-Unsubscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ofw>,
	<mailto:ofw-request@lists.openfabrics.org?subject=unsubscribe>
List-Archive: <http://lists.openfabrics.org/pipermail/ofw>
List-Post: <mailto:ofw@lists.openfabrics.org>
List-Help: <mailto:ofw-request@lists.openfabrics.org?subject=help>
List-Subscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ofw>,
	<mailto:ofw-request@lists.openfabrics.org?subject=subscribe>
Sender: ofw-bounces@lists.openfabrics.org
Errors-To: ofw-bounces@lists.openfabrics.org
To: "Smith, Stan" <stan.smith@intel.com>, 'Sasha Khapyorsky' <sashak@voltaire.com>
Cc: linux-rdma@vger.kernel.org, ofw@lists.openfabrics.org
List-Id: linux-rdma@vger.kernel.org

>Contain pthread definitions with ifdef HAVE_LIBPTHREAD
>
>Signed-off-by: stan smith <stan.smith@intel.com>
>
>diff --git a/opensm/include/vendor/osm_vendor_ibumad.h
>b/opensm/include/vendor/osm_vendor_ibumad.h
>index 0a4692d..d523412 100644
>--- a/opensm/include/vendor/osm_vendor_ibumad.h
>+++ b/opensm/include/vendor/osm_vendor_ibumad.h
>@@ -160,8 +160,13 @@ typedef struct _osm_vendor {
> 	char ca_names[OSM_UMAD_MAX_CAS][UMAD_CA_NAME_LEN];
> 	vendor_match_tbl_t mtbl;
> 	umad_port_t umad_port;
>+#ifdef HAVE_LIBPTHREAD
> 	pthread_mutex_t cb_mutex;
> 	pthread_mutex_t match_tbl_mutex;
>+#else
>+	cl_mutex_t cb_mutex;
>+	cl_mutex_t match_tbl_mutex;
>+#endif

complib is available on both platforms, why not just use it?

Alternately, #define cl_mutex_t pthread_mutex_t and avoid the #ifdef's
