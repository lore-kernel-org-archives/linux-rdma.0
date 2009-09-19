From: Sasha Khapyorsky <sashak@voltaire.com>
Subject: [ofa-general] Re: [PATCH][TRIVIAL] infiniband-diags/: Cosmetic
 changes, mostly typos
Date: Sat, 19 Sep 2009 20:58:32 +0300
Message-ID: <20090919175832.GI13667@me>
References: <829ded920909150439h585f05e3hf0174713ecd2faf4@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <general-bounces@lists.openfabrics.org>
Content-Disposition: inline
In-Reply-To: <829ded920909150439h585f05e3hf0174713ecd2faf4@mail.gmail.com>
List-Unsubscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/general>,
	<mailto:general-request@lists.openfabrics.org?subject=unsubscribe>
List-Archive: <http://lists.openfabrics.org/pipermail/general>
List-Post: <mailto:general@lists.openfabrics.org>
List-Help: <mailto:general-request@lists.openfabrics.org?subject=help>
List-Subscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/general>,
	<mailto:general-request@lists.openfabrics.org?subject=subscribe>
Sender: general-bounces@lists.openfabrics.org
Errors-To: general-bounces@lists.openfabrics.org
To: Keshetti Mahesh <keshetti.mahesh@gmail.com>
Cc: OFED mailing list <linux-rdma@vger.kernel.org>, OFED mailing list <general@lists.openfabrics.org>
List-Id: linux-rdma@vger.kernel.org

On 17:09 Tue 15 Sep     , Keshetti Mahesh wrote:
> Cosmetic changes
> 
> Signed-off-by: Keshetti Mahesh < keshetti.mahesh@gmail.com>

The patch is malformed (broken long lines and mangled whitespaces).

Applied by hands. Thanks.

Sasha

> ---
> 
> diff --git a/infiniband-diags/scripts/ibcheckwidth.in
> b/infiniband-diags/scripts/ibcheckwidth.in
> index 6b723c5..cbb154c 100644
> --- a/infiniband-diags/scripts/ibcheckwidth.in
> +++ b/infiniband-diags/scripts/ibcheckwidth.in
> @@ -77,7 +77,7 @@ BEGIN {
>  function check_node(lid)
>  {
>         nodechecked=1
> -       if (system("'$IBPATH'/ibchecknode'"$ca_info"' '$gflags'
> '$verbose' " lid)) {
> +       if (system("'$IBPATH'/ibchecknode '"$ca_info"' '$gflags'
> '$verbose' " lid)) {
>                 ne++
>                 badnode=1
>                 return
> @@ -113,7 +113,7 @@ function check_node(lid)
>                 }
>                 sub("\\(.*\\)", "", port)
>                 gsub("[\\[\\]]", "", port)
> -               if (system("'$IBPATH'/ibcheckportwidth'"$ca_info"'
> '$gflags' '$verbose' " lid " " port)) {
> +               if (system("'$IBPATH'/ibcheckportwidth '"$ca_info"'
> '$gflags' '$verbose' " lid " " port)) {
>                         if (!'$v' && oldlid != lid) {
>                                 print "# Checked " ntype ": nodeguid
> 0x" nodeguid " with failure"
>                                 oldlid = lid
> diff --git a/infiniband-diags/src/ibportstate.c
> b/infiniband-diags/src/ibportstate.c
> index 76e74f7..018bc9a 100644
> --- a/infiniband-diags/src/ibportstate.c
> +++ b/infiniband-diags/src/ibportstate.c
> @@ -349,7 +349,7 @@ int main(int argc, char **argv)
>                             get_port_info(&peerportid, data, peerlocalportnum,
>                                           port_op);
>                         if (err < 0)
> -                               IBERROR("smp query peer portinfofailed");
> +                               IBERROR("smp query peer portinfo failed");
> 
>                         mad_decode_field(data, IB_PORT_LINK_WIDTH_ENABLED_F,
>                                          &peerlwe);
> diff --git a/infiniband-diags/man/ibcheckportwidth.8
> b/infiniband-diags/man/ibcheckportwidth.8
> index 85c06fc..c368467 100644
> --- a/infiniband-diags/man/ibcheckportwidth.8
> +++ b/infiniband-diags/man/ibcheckportwidth.8
> @@ -4,7 +4,7 @@
>  ibcheckportwidth \- validate IB port for 1x link width
> 
>  .SH SYNOPSIS
> -.B ibcheckport
> +.B ibcheckportwidth
>  [\-h] [\-v] [\-N | \-nocolor] [\-G] [\-C ca_name] [\-P ca_port]
>  [\-t(imeout) timeout_ms]  <lid|guid> <port>
>  --
> 1.6.4.2
> 
> -- 
> Keshetti Mahesh
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
