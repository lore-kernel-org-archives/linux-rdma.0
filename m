From: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH 26/28] Avoid gcc 5.4 warning -Wunused-result
Date: Wed, 14 Sep 2016 19:35:42 +0300
Message-ID: <3b8df987-b422-a59c-4dc0-8a99524ab45e@dev.mellanox.co.il>
References: <1473109698-31408-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <1473109698-31408-27-git-send-email-jgunthorpe@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1473109698-31408-27-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Devesh Sharma <Devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Tatyana Nikolova <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Vladimir Sokolovsky <vlad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 9/6/2016 12:08 AM, Jason Gunthorpe wrote:
> It used to be you could suppress this with (void), however the gcc
> developers have decided to get rid of that.
>
> So, look closely at each occurrence and decide what to do:
> - *pingpong: Join the error handling with the if statement directly
>    above
> - niegh: read on a timer_fd should never fail, so just use assert.
>    The assert is compiled out for Release builds so this is no-change
> - acm: Failure of ucma_set_server_port is detected by a 0 return
>    so check fscanf and return appropriately. This is no change since
>    fscanf failure was assumed to have left server_port as 0 (though
>    I doubt the standard supports that usage)
> - rsocket: This looks super sketchy. At least lets make the intent clear
>    with a read_all/write_all wrapper that calls assert. Most likely
>    this code is wrong..
>    Mangle the code with failable_fscanf to make it clear, but as with
>    acm, I don't think the standard supports this usage.
>
> Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
> ---
>  libibverbs/examples/rc_pingpong.c  | 15 +++++-----
>  libibverbs/examples/srq_pingpong.c | 13 +++++++--
>  libibverbs/examples/uc_pingpong.c  | 15 +++++-----
>  libibverbs/examples/ud_pingpong.c  | 17 +++++-------
>  libibverbs/src/neigh.c             |  7 +++--
>  librdmacm/src/acm.c                |  3 +-
>  librdmacm/src/rsocket.c            | 56 +++++++++++++++++++++++++++-----------
>  7 files changed, 78 insertions(+), 48 deletions(-)
>
> diff --git a/libibverbs/examples/rc_pingpong.c b/libibverbs/examples/rc_pingpong.c
> index 1fad16a0be7c..7bcc413a0f1d 100644
> --- a/libibverbs/examples/rc_pingpong.c
> +++ b/libibverbs/examples/rc_pingpong.c
> @@ -208,14 +208,13 @@ static struct pingpong_dest *pp_client_exch_dest(const char *servername, int por
>  		goto out;
>  	}
>
> -	if (read(sockfd, msg, sizeof msg) != sizeof msg) {
> -		perror("client read");
> -		fprintf(stderr, "Couldn't read remote address\n");
> +	if (read(sockfd, msg, sizeof msg) != sizeof msg ||
> +	    write(sockfd, "done", sizeof "done") != sizeof "done") {
> +		perror("client read/write");
> +		fprintf(stderr, "Couldn't read/write remote address\n");

It's just an example, however, better to have an accurate error message 
and separate into 2 stubs.

>  		goto out;
>  	}
>
> -	write(sockfd, "done", sizeof "done");
> -
>  	rem_dest = malloc(sizeof *rem_dest);
>  	if (!rem_dest)
>  		goto out;
> @@ -316,14 +315,14 @@ static struct pingpong_dest *pp_server_exch_dest(struct pingpong_context *ctx,
>  	gid_to_wire_gid(&my_dest->gid, gid);
>  	sprintf(msg, "%04x:%06x:%06x:%s", my_dest->lid, my_dest->qpn,
>  							my_dest->psn, gid);
> -	if (write(connfd, msg, sizeof msg) != sizeof msg) {
> -		fprintf(stderr, "Couldn't send local address\n");
> +	if (write(connfd, msg, sizeof msg) != sizeof msg ||
> +	    read(connfd, msg, sizeof msg) != sizeof msg) {
> +		fprintf(stderr, "Couldn't send/recv local address\n");

Same comment as of above.

>  		free(rem_dest);
>  		rem_dest = NULL;
>  		goto out;
>  	}
>
> -	read(connfd, msg, sizeof msg);
>
>  out:
>  	close(connfd);
> diff --git a/libibverbs/examples/srq_pingpong.c b/libibverbs/examples/srq_pingpong.c
> index 929b736545c7..e6492dc553fd 100644
> --- a/libibverbs/examples/srq_pingpong.c
> +++ b/libibverbs/examples/srq_pingpong.c
> @@ -222,8 +222,10 @@ static struct pingpong_dest *pp_client_exch_dest(const char *servername, int por
>  		wire_gid_to_gid(gid, &rem_dest[i].gid);
>  	}
>
> -	write(sockfd, "done", sizeof "done");
> -
> +	if (write(sockfd, "done", sizeof "done") != sizeof "done") {
> +		perror("client write");
> +		goto out;
> +	}
>  out:
>  	close(sockfd);
>  	return rem_dest;
> @@ -333,7 +335,12 @@ static struct pingpong_dest *pp_server_exch_dest(struct pingpong_context *ctx,
>  		}
>  	}
>
> -	read(connfd, msg, sizeof msg);
> +	if (read(connfd, msg, sizeof msg) != sizeof msg) {
> +		perror("client write");
> +		free(rem_dest);
> +		rem_dest = NULL;
> +		goto out;
> +	}
>
>  out:
>  	close(connfd);
> diff --git a/libibverbs/examples/uc_pingpong.c b/libibverbs/examples/uc_pingpong.c
> index 3802e3821773..d132de98694a 100644
> --- a/libibverbs/examples/uc_pingpong.c
> +++ b/libibverbs/examples/uc_pingpong.c
> @@ -176,13 +176,13 @@ static struct pingpong_dest *pp_client_exch_dest(const char *servername, int por
>  		goto out;
>  	}
>
> -	if (read(sockfd, msg, sizeof msg) != sizeof msg) {
> -		perror("client read");
> -		fprintf(stderr, "Couldn't read remote address\n");
> +	if (read(sockfd, msg, sizeof msg) != sizeof msg ||
> +	    write(sockfd, "done", sizeof "done") != sizeof "done") {
> +		perror("client read/write");
> +		fprintf(stderr, "Couldn't read/write remote address\n");
>  		goto out;
>  	}
>
> -	write(sockfd, "done", sizeof "done");
>
>  	rem_dest = malloc(sizeof *rem_dest);
>  	if (!rem_dest)
> @@ -284,15 +284,14 @@ static struct pingpong_dest *pp_server_exch_dest(struct pingpong_context *ctx,
>  	gid_to_wire_gid(&my_dest->gid, gid);
>  	sprintf(msg, "%04x:%06x:%06x:%s", my_dest->lid, my_dest->qpn,
>  							my_dest->psn, gid);
> -	if (write(connfd, msg, sizeof msg) != sizeof msg) {
> -		fprintf(stderr, "Couldn't send local address\n");
> +	if (write(connfd, msg, sizeof msg) != sizeof msg ||
> +	    read(connfd, msg, sizeof msg) != sizeof msg) {
> +		fprintf(stderr, "Couldn't send/recv local address\n");
>  		free(rem_dest);
>  		rem_dest = NULL;
>  		goto out;
>  	}
>
> -	read(connfd, msg, sizeof msg);
> -
>  out:
>  	close(connfd);
>  	return rem_dest;
> diff --git a/libibverbs/examples/ud_pingpong.c b/libibverbs/examples/ud_pingpong.c
> index fa99b9e51dfb..67da4bd90f32 100644
> --- a/libibverbs/examples/ud_pingpong.c
> +++ b/libibverbs/examples/ud_pingpong.c
> @@ -176,14 +176,13 @@ static struct pingpong_dest *pp_client_exch_dest(const char *servername, int por
>  		goto out;
>  	}
>
> -	if (read(sockfd, msg, sizeof msg) != sizeof msg) {
> -		perror("client read");
> -		fprintf(stderr, "Couldn't read remote address\n");
> +	if (read(sockfd, msg, sizeof msg) != sizeof msg ||
> +	    write(sockfd, "done", sizeof "done") != sizeof "done") {
> +		perror("client read/write");
> +		fprintf(stderr, "Couldn't read/write remote address\n");
>  		goto out;
>  	}
>
> -	write(sockfd, "done", sizeof "done");
> -
>  	rem_dest = malloc(sizeof *rem_dest);
>  	if (!rem_dest)
>  		goto out;
> @@ -282,15 +281,13 @@ static struct pingpong_dest *pp_server_exch_dest(struct pingpong_context *ctx,
>  	gid_to_wire_gid(&my_dest->gid, gid);
>  	sprintf(msg, "%04x:%06x:%06x:%s", my_dest->lid, my_dest->qpn,
>  							my_dest->psn, gid);
> -	if (write(connfd, msg, sizeof msg) != sizeof msg) {
> -		fprintf(stderr, "Couldn't send local address\n");
> +	if (write(connfd, msg, sizeof msg) != sizeof msg ||
> +	    read(connfd, msg, sizeof msg) != sizeof msg) {
> +		fprintf(stderr, "Couldn't send/recv local address\n");
>  		free(rem_dest);
>  		rem_dest = NULL;
>  		goto out;
>  	}
> -
> -	read(connfd, msg, sizeof msg);
> -
>  out:
>  	close(connfd);
>  	return rem_dest;
> diff --git a/libibverbs/src/neigh.c b/libibverbs/src/neigh.c
> index 6b6e58cd52f8..5acfcf06fcde 100644
> --- a/libibverbs/src/neigh.c
> +++ b/libibverbs/src/neigh.c
> @@ -19,6 +19,7 @@
>  #include <unistd.h>
>  #include <ifaddrs.h>
>  #include <netdb.h>
> +#include <assert.h>
>  #ifndef _LINUX_IF_H
>  #include <net/if.h>
>  #else
> @@ -372,9 +373,11 @@ static struct nl_addr *process_get_neigh_mac(
>
>  			if (FD_ISSET(timer_fd, &fdset)) {
>  				uint64_t read_val;
> +				ssize_t rc;
>
> -				(void)read(timer_fd, &read_val,
> -					   sizeof(read_val));
> +				rc =
> +				    read(timer_fd, &read_val, sizeof(read_val));
> +				assert(rc == sizeof(read_val));
>  				if (++retries >=  NUM_OF_TRIES) {
>  					if (!errno)
>  						errno = EDESTADDRREQ;
> diff --git a/librdmacm/src/acm.c b/librdmacm/src/acm.c
> index f0da01e6d286..c097bb923b55 100644
> --- a/librdmacm/src/acm.c
> +++ b/librdmacm/src/acm.c
> @@ -121,7 +121,8 @@ static int ucma_set_server_port(void)
>  	FILE *f;
>
>  	if ((f = fopen("/var/run/ibacm.port", "r" STREAM_CLOEXEC))) {
> -		fscanf(f, "%" SCNu16, &server_port);
> +		if (fscanf(f, "%" SCNu16, &server_port) != 1)
> +			server_port = 0;
>  		fclose(f);
>  	}
>  	return server_port;
> diff --git a/librdmacm/src/rsocket.c b/librdmacm/src/rsocket.c
> index 818505fbe02e..5645f40d2460 100644
> --- a/librdmacm/src/rsocket.c
> +++ b/librdmacm/src/rsocket.c
> @@ -404,6 +404,20 @@ struct ds_udp_header {
>
>  #define ds_next_qp(qp) container_of((qp)->list.next, struct ds_qp, list)
>
> +static void write_all(int fd, const void *msg, size_t len)
> +{
> +	// FIXME: if fd is a socket this really needs to handle EINTR and other conditions.
> +	ssize_t rc = write(fd, msg, len);
> +	assert(rc == len);
> +}
> +
> +static void read_all(int fd, void *msg, size_t len)
> +{
> +	// FIXME: if fd is a socket this really needs to handle EINTR and other conditions.
> +	ssize_t rc = read(fd, msg, len);
> +	assert(rc == len);
> +}
> +
>  static void ds_insert_qp(struct rsocket *rs, struct ds_qp *qp)
>  {
>  	if (!rs->qp_list)
> @@ -444,8 +458,8 @@ static int rs_notify_svc(struct rs_svc *svc, struct rsocket *rs, int cmd)
>  	msg.cmd = cmd;
>  	msg.status = EINVAL;
>  	msg.rs = rs;
> -	write(svc->sock[0], &msg, sizeof msg);
> -	read(svc->sock[0], &msg, sizeof msg);
> +	write_all(svc->sock[0], &msg, sizeof msg);
> +	read_all(svc->sock[0], &msg, sizeof msg);
>  	ret = rdma_seterrno(msg.status);
>  	if (svc->cnt)
>  		goto unlock;
> @@ -484,6 +498,15 @@ static int rs_scale_to_value(int value, int bits)
>  	       value : (value & ~(1 << (bits - 1))) << bits;
>  }
>
> +/* gcc > ~5 will not allow (void)fscanf to suppress -Wunused-result, but this
> +   will do it.  In this case ignoring the result is OK (but horribly
> +   unfriendly to user) since the library has a sane default. */
> +#define failable_fscanf(f, fmt, ...)                                           \
> +	{                                                                      \
> +		int rc = fscanf(f, fmt, __VA_ARGS__);                          \
> +		(void) rc;                                                     \
> +	}
> +
>  void rs_configure(void)
>  {
>  	FILE *f;
> @@ -501,27 +524,27 @@ void rs_configure(void)
>  	ucma_ib_init();
>
>  	if ((f = fopen(RS_CONF_DIR "/polling_time", "r"))) {
> -		(void) fscanf(f, "%u", &polling_time);
> +		failable_fscanf(f, "%u", &polling_time);
>  		fclose(f);
>  	}
>
>  	if ((f = fopen(RS_CONF_DIR "/inline_default", "r"))) {
> -		(void) fscanf(f, "%hu", &def_inline);
> +		failable_fscanf(f, "%hu", &def_inline);
>  		fclose(f);
>  	}
>
>  	if ((f = fopen(RS_CONF_DIR "/sqsize_default", "r"))) {
> -		(void) fscanf(f, "%hu", &def_sqsize);
> +		failable_fscanf(f, "%hu", &def_sqsize);
>  		fclose(f);
>  	}
>
>  	if ((f = fopen(RS_CONF_DIR "/rqsize_default", "r"))) {
> -		(void) fscanf(f, "%hu", &def_rqsize);
> +		failable_fscanf(f, "%hu", &def_rqsize);
>  		fclose(f);
>  	}
>
>  	if ((f = fopen(RS_CONF_DIR "/mem_default", "r"))) {
> -		(void) fscanf(f, "%u", &def_mem);
> +		failable_fscanf(f, "%u", &def_mem);
>  		fclose(f);
>
>  		if (def_mem < 1)
> @@ -529,14 +552,14 @@ void rs_configure(void)
>  	}
>
>  	if ((f = fopen(RS_CONF_DIR "/wmem_default", "r"))) {
> -		(void) fscanf(f, "%u", &def_wmem);
> +		failable_fscanf(f, "%u", &def_wmem);
>  		fclose(f);
>  		if (def_wmem < RS_SNDLOWAT)
>  			def_wmem = RS_SNDLOWAT << 1;
>  	}
>
>  	if ((f = fopen(RS_CONF_DIR "/iomap_size", "r"))) {
> -		(void) fscanf(f, "%hu", &def_iomap_size);
> +		failable_fscanf(f, "%hu", &def_iomap_size);
>  		fclose(f);
>
>  		/* round to supported values */
> @@ -3345,7 +3368,8 @@ static int rs_set_keepalive(struct rsocket *rs, int on)
>  	if (on) {
>  		if (!rs->keepalive_time) {
>  			if ((f = fopen("/proc/sys/net/ipv4/tcp_keepalive_time", "r"))) {
> -				(void) fscanf(f, "%u", &rs->keepalive_time);
> +				if (fscanf(f, "%u", &rs->keepalive_time) != 1)
> +					rs->keepalive_time = 7200;
>  				fclose(f);
>  			} else {
>  				rs->keepalive_time = 7200;
> @@ -3985,7 +4009,7 @@ static void udp_svc_process_sock(struct rs_svc *svc)
>  {
>  	struct rs_svc_msg msg;
>
> -	read(svc->sock[1], &msg, sizeof msg);
> +	read_all(svc->sock[1], &msg, sizeof msg);
>  	switch (msg.cmd) {
>  	case RS_SVC_ADD_DGRAM:
>  		msg.status = rs_svc_add_rs(svc, msg.rs);
> @@ -4009,7 +4033,7 @@ static void udp_svc_process_sock(struct rs_svc *svc)
>  		break;
>  	}
>
> -	write(svc->sock[1], &msg, sizeof msg);
> +	write_all(svc->sock[1], &msg, sizeof msg);
>  }
>
>  static uint8_t udp_svc_sgid_index(struct ds_dest *dest, union ibv_gid *sgid)
> @@ -4184,7 +4208,7 @@ static void *udp_svc_run(void *arg)
>  	ret = rs_svc_grow_sets(svc, 4);
>  	if (ret) {
>  		msg.status = ret;
> -		write(svc->sock[1], &msg, sizeof msg);
> +		write_all(svc->sock[1], &msg, sizeof msg);
>  		return (void *) (uintptr_t) ret;
>  	}
>
> @@ -4222,7 +4246,7 @@ static void tcp_svc_process_sock(struct rs_svc *svc)
>  	struct rs_svc_msg msg;
>  	int i;
>
> -	read(svc->sock[1], &msg, sizeof msg);
> +	read_all(svc->sock[1], &msg, sizeof msg);
>  	switch (msg.cmd) {
>  	case RS_SVC_ADD_KEEPALIVE:
>  		msg.status = rs_svc_add_rs(svc, msg.rs);
> @@ -4253,7 +4277,7 @@ static void tcp_svc_process_sock(struct rs_svc *svc)
>  	default:
>  		break;
>  	}
> -	write(svc->sock[1], &msg, sizeof msg);
> +	write_all(svc->sock[1], &msg, sizeof msg);
>  }
>
>  /*
> @@ -4282,7 +4306,7 @@ static void *tcp_svc_run(void *arg)
>  	ret = rs_svc_grow_sets(svc, 16);
>  	if (ret) {
>  		msg.status = ret;
> -		write(svc->sock[1], &msg, sizeof msg);
> +		write_all(svc->sock[1], &msg, sizeof msg);
>  		return (void *) (uintptr_t) ret;
>  	}
>
>

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
