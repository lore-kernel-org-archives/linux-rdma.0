From: Sridhar Samudrala <sri-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 5/7] librdmacm/rspreload: Do not block connect when
 supporting fork
Date: Fri, 17 Aug 2012 17:40:13 -0700
Message-ID: <1345250413.1128.36.camel@oc1677441337.ibm.com>
References: <1828884A29C6694DAF28B7E6B8A8237346A8997B@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A8237346A8997B-P5GAC/sN6hmkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, 2012-08-16 at 19:24 +0000, Hefty, Sean wrote:
> Many FTP servers require fork support.  However, FTP clients,
> such as ncftp, will perform the following call sequence:
> 
> send PASV request to server over connection 1
>          server will listen for connection 2
> issue nonblocking connect to server
> send ACCEPT request to server over connection 1
>          server will accept connection 2
> 
> The current fork support converts all nonblocking connect
> calls to blocking.  The result is that the FTP client ends up
> blocked waiting for the server to accept the connection,
> which it will never do.
> 
> To handle this case, we have the active side follow the same
> rule as the server side and defer establishing the rsocket
> connection until the user calls the first data transfer routine.

I just updated the repository and noticed that we are falling back to
normal sockets even with preload.
After some debugging, found a couple of issuse. See inline.

Thanks
Sridhar

> 
> Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> ---
.....

> @@ -453,37 +486,57 @@ int accept(int socket, struct sockaddr *addr, socklen_t *addrlen)
>   * We can't fork RDMA connections and pass them from the parent to the child
>   * process.  Instead, we need to establish the RDMA connection after calling
>   * fork.  To do this, we delay establishing the RDMA connection until we try
> - * to send/receive on the server side.  On the client side, we don't expect
> - * to fork, so we switch from a TCP connection to an rsocket when connecting.
> + * to send/receive on the server side.
>   */
> -static int fork_active(int socket, const struct sockaddr *addr, socklen_t addrlen)
> +static void fork_active(int socket)
>  {
> -	int fd, ret;
> +	struct sockaddr_storage addr;
> +	int sfd, dfd, ret;
> +	socklen_t len;
>  	uint32_t msg;
>  	long flags;
> 
> -	fd = fd_getd(socket);
> -	flags = real.fcntl(fd, F_GETFL);
> -	real.fcntl(fd, F_SETFL, 0);
> -	ret = real.connect(fd, addr, addrlen);
> +	sfd = fd_getd(socket);
> +
> +	len = sizeof addr;
> +	ret = real.getpeername(sfd, (struct sockaddr *) &addr, &len);
>  	if (ret)
> -		return ret;
> +		goto err1;
> 
> -	ret = real.recv(fd, &msg, sizeof msg, MSG_PEEK);
> -	if ((ret != sizeof msg) || msg) {
> -		fd_store(socket, fd, fd_normal);
> -		return 0;
> -	}
> +	dfd = rsocket(addr.ss_family, SOCK_STREAM, 0);
> +	if (dfd < 0)
> +		goto err1;
> 
> -	real.fcntl(fd, F_SETFL, flags);
> -	ret = transpose_socket(socket, fd_rsocket);
> -	if (ret < 0)
> -		return ret;
> +	flags = real.fcntl(sfd, F_GETFL);
> +	real.fcntl(sfd, F_SETFL, 0);
> +	ret = real.recv(sfd, &msg, sizeof msg, MSG_PEEK);
> +	real.fcntl(sfd, F_SETFL, flags);
> +	if ((ret != sizeof msg) || msg)
> +		goto err2;
> +
> +	ret = rconnect(ret, (struct sockaddr *) &addr, len);

The first parameter to rconnect is incorrect. It should be dfd

> +	if (ret)
> +		goto err2;
> 
> -	real.close(fd);
> -	return rconnect(ret, addr, addrlen);
> +	set_rsocket_options(dfd);
> +	copysockopts(dfd, sfd, &rs, &real);
> +	real.shutdown(sfd, SHUT_RDWR);
> +	real.close(sfd);
> +	fd_store(socket, dfd, fd_rsocket, fd_ready);
> +	return;
> +
> +err2:
> +	rclose(dfd);
> +err1:
> +	fd_store(socket, sfd, fd_normal, fd_ready);
>  }
> 
> +/*
> + * The server will start listening for the new connection, then send a
> + * message to the active side when the listen is ready.  This does leave
> + * fork unsupported in the following case: the server is nonblocking and
> + * calls select/poll waiting to receive data from the client.
> + */
>  static void fork_passive(int socket)
>  {
>  	struct sockaddr_in6 sin6;
> @@ -541,7 +594,7 @@ static void fork_passive(int socket)
>  	copysockopts(dfd, sfd, &rs, &real);
>  	real.shutdown(sfd, SHUT_RDWR);
>  	real.close(sfd);
> -	fd_store(socket, dfd, fd_rsocket);
> +	fd_store(socket, dfd, fd_rsocket, fd_ready);
> 
>  lclose:
>  	rclose(lfd);
> @@ -550,7 +603,7 @@ sclose:
>  	sem_close(sem);
>  out:
>  	if (ret)
> -		fd_store(socket, sfd, fd_normal);
> +		fd_store(socket, sfd, fd_normal, fd_ready);
>  }
> 
>  static inline enum fd_type fd_fork_get(int index, int *fd)
> @@ -559,8 +612,10 @@ static inline enum fd_type fd_fork_get(int index, int *fd)
> 
>  	fdi = idm_lookup(&idm, index);
>  	if (fdi) {
> -		if (fdi->type == fd_fork)
> +		if (fdi->type == fd_fork_passive)

fd_fork is no longer a fd_type. So this should be fdi->state

>  			fork_passive(index);
> +		else if (fdi->type == fd_fork_active)

Same here

> +			fork_active(index);
>  		*fd = fdi->fd;
>  		return fdi->type;
> 
> @@ -574,10 +629,7 @@ int connect(int socket, const struct sockaddr *addr, socklen_t addrlen)
>  {
>  	int fd, ret;
> 
> -	switch (fd_get(socket, &fd)) {
> -	case fd_fork:
> -		return fork_active(socket, addr, addrlen);
> -	case fd_rsocket:
> +	if (fd_get(socket, &fd) == fd_rsocket) {
>  		ret = rconnect(fd, addr, addrlen);
>  		if (!ret || errno == EINPROGRESS)
>  			return ret;
> @@ -588,9 +640,8 @@ int connect(int socket, const struct sockaddr *addr, socklen_t addrlen)
> 
>  		rclose(fd);
>  		fd = ret;
> -		break;
> -	default:
> -		break;
> +	} else if (fd_gets(socket) == fd_fork) {
> +		fd_store(socket, fd, fd_normal, fd_fork_active);
>  	}
> 
>  	return real.connect(fd, addr, addrlen);
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
