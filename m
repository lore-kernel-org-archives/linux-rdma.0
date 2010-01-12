From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: [PATCH] infiniband-diags: -V, --version: exit with zero status
Date: Tue, 12 Jan 2010 11:22:46 +0200
Message-ID: <20100112092246.GE26089@me>
References: <bug-1886-143@https.bugs.openfabrics.org/>
 <2ED289D4E09FBD4D92D911E869B97FDD024A3B3F@mtlexch01.mtl.com>
 <20100105101346.GM26940@me>
 <2ED289D4E09FBD4D92D911E869B97FDD024A3D1F@mtlexch01.mtl.com>
 <4DB33AEBD6F349EABE6AA1834AFBFC6B@amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4DB33AEBD6F349EABE6AA1834AFBFC6B-Zpru7NauK7drdx17CPfAsdBPR1lH4CV8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Leonid Keller' <leonid-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, ofw_list <ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>, Yevgeny Kliteynik <kliteyn-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, Regev Lev <regevl-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


When -V, --version command line option is used exit with zero status
after a version showing.

Signed-off-by: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
---

On 08:03 Tue 05 Jan     , Sean Hefty wrote:
> 
> Changes to the above components should be made to Sasha's tree first, or they
> risk being lost when I update the windows copy.

 infiniband-diags/src/ibdiag_common.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/infiniband-diags/src/ibdiag_common.c b/infiniband-diags/src/ibdiag_common.c
index 735b898..99861f1 100644
--- a/infiniband-diags/src/ibdiag_common.c
+++ b/infiniband-diags/src/ibdiag_common.c
@@ -147,7 +147,7 @@ static int process_opt(int ch, char *optarg)
 		break;
 	case 'V':
 		fprintf(stderr, "%s %s\n", prog_name, get_build_version());
-		exit(2);
+		exit(0);
 	case 'e':
 		madrpc_show_errors(1);
 		break;
-- 
1.6.6

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
