From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: asynchronous operation with poll()
Date: Tue, 9 Nov 2010 13:44:52 -0700
Message-ID: <20101109204452.GG909@obsidianresearch.com>
References: <ibbr34$ima$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <ibbr34$ima$1@dough.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jonathan Rosser <jonathan.rosser-gjMux1o1B1/QXOPxS62xeg@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Nov 09, 2010 at 03:58:27PM +0000, Jonathan Rosser wrote:
> I have a client and server test program to explore fully
> asynchronous communication written as close to a conventional
> sockets application as possible and am encountering difficulty.

Broadly it looks to me like your actions are in the wrong order.
A poll based RDMA loop should look like this:

- exit poll
- Check poll bit
- call ibv_get_cq_event
- call ibv_req_notify_cq
- repeatedly call ibv_poll_cq (while rc == num requested)
- Issue new work
- return to poll

Generally, for your own sanity, I recommend splitting into 3 functions
- Do the stuff with ibv_get_cq_event
- Drain and process WC's
- Issue new work

Most real use cases will also want to call the latter two functions
from other waiters in the poll loop (ie whatever your wak_fds is for).

Some random mild comments for you:

> >  const int NUM_FDS = 4;
> >
> >  const int POLL_CM = 0;
> >  const int POLL_RECV_CQ = 1;
> >  const int POLL_SEND_CQ = 2;
> >  const int POLL_WAKE = 3;

You can use an enum for these constants

> >  //prime notification of events on the recv completion queue
> >  ibv_req_notify_cq(cm_id->recv_cq, 0);

Do this earlier, before posting recvs, otherwise you could race
getting your first recv.


> >  while(ret == 0)
> >  {
> >    memset(fds, 0, sizeof(pollfd) * NUM_FDS);
> >    fds[POLL_CM].fd = cm_channel->fd;
> >    fds[POLL_CM].events = POLLIN;
> >
> >    fds[POLL_RECV_CQ].fd = cm_id->recv_cq_channel->fd;
> >    fds[POLL_RECV_CQ].events = POLLIN;
> >
> >    fds[POLL_SEND_CQ].fd = cm_id->send_cq_channel->fd;
> >    fds[POLL_SEND_CQ].events = POLLIN;
> >
> >    fds[POLL_WAKE].fd = wake_fds[0];
> >    fds[POLL_WAKE].events = POLLIN;

The efficient use of poll does not put these inside the main loop. You
only need to initialize fd and events once at the start.

> >    if(fds[POLL_CM].revents & POLLIN) {
> >      struct rdma_cm_event *cm_event;
> >      ret = rdma_get_cm_event(cm_channel, &cm_event);
> >      if(ret) {
> >        perror("client connection rdma_get_cm_event");
> >      }
> >      fprintf(stderr, "Got cm event %s\n", rdma_event_str(cm_event->event));
> >
> >      if(cm_event->event == RDMA_CM_EVENT_ESTABLISHED) {
> >        //send as soon as we are connected
> >        ibv_req_notify_cq(cm_id->send_cq, 0);

Again, this should be done once, right after the cq is created.

> >    //if the send completed
> >    if(fds[POLL_SEND_CQ].revents & POLLIN) {
> >      struct ibv_cq *cq;
> >      struct ibv_wc wc[10];
> >      void *context;
> >      int num_send = ibv_poll_cq(cm_id->send_cq, 10, &wc[0]);
> >      if(num_send == 0) fprintf(stderr, ".");

Check that num_sends == 10 and loop again

> >      for(int i=0; i<num_send; i++) {
> >        fprintf(stderr,"Got SEND CQ event : %d of %d %s\n", i, num_send, ibv_wc_status_str(wc[i].status));
> >        ibv_get_cq_event(cm_id->send_cq_channel, &cq, &context);

cq_events are not tied to send WC's, this should be done
exactly once, prior to calling ibv_poll_cq

> >      //expensive call, ack all received events together
> >      ibv_ack_cq_events(cm_id->send_cq, num_send);

You don't have to do this at all in the loop unless you are
doing multithreaded things. Using num_send is wrong, I use this:

bool checkCQPoll(struct pollfd &p)
{
    if ((p.revents & POLLIN) == 0 ||
        ibv_get_cq_event(comp,&jnk1,&jnk2) != 0)
        return false;

    compEvents++;
    if (compEvents >= INT_MAX)
    {
        ibv_ack_cq_events(cq,compEvents);
        compEvents = 0;
    }
    int rc;
    if ((rc = ibv_req_notify_cq(cq,0)) == -1)
    {
        errno = rc;
	[..]

And then call ibv_ack_cq_events(cq,compEvents) before trying to
destroy the CQ. All it used for it synchronizing exits between threads.

> >      ibv_req_notify_cq(cm_id->send_cq, 0);

Do right after calling ibv_get_cq_event

> >    //if the receive completed, prepare to receive more
> >    if(fds[POLL_RECV_CQ].revents & POLLIN) {
> >      struct ibv_cq *cq;
> >      struct ibv_wc wc[10];
> >      void *context;
> >      int num_recv=ibv_poll_cq(cm_id->recv_cq, 10, &wc[0]);

Same problems as for send, they should be the same. Implement a
function like my checkCQPoll example and call it for both cases.

Continually posting sends and recvs will get you into trouble, you
will run out of recvs and get RNR's. These days the wisdom for
implementing RDMA is that you should have explicit message flow
control. Ie for something simple like this you could say that getting
a recv means another send is OK, but you still need a mechanism to
wait for a send buffer to be returned on the send CQ - there is no
ordering guarantee.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
