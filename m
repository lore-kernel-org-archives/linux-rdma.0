From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: user SA notifications, redux
Date: Wed, 27 Oct 2010 10:05:56 -0400
Message-ID: <4CC831C4.5030502@dev.mellanox.co.il>
References: <4CBF0AD7.80904@systemfabricworks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4CBF0AD7.80904-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mike Heinz <michael.heinz-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ewg-G2znmakfqn7U1rindQTSdQ@public.gmane.org, vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 10/13/2010 10:17 AM, Mike Heinz wrote:
>
> Way back in May I proposed this prototype for adding SA notifications to the verbs API, but no one ever said yes or no. Vlad - I'm not even sure you were part of the conversation at the time, it was originally about a new API, but you should be aware of it since the conversation changed to adding the user-space capability to libibverbs.
>
> Now that 1.5.2 is out the door, can we revisit this and try to get this and the matching kernel changes into the next release?
>
> ===========================================
>
> API for Proposal for adding ib_usa to the Linux Infiniband Subsystem
> Mike Heinz
> Mon, 24 May 2010 12:31:16 -0700
>
> I spent the weekend thinking about your feedback Friday, and I'm concerned that
> it widens the scope too far beyond what the current code is meant to do.
>
> ib_usa isn't meant to be a general GSI interface, it's meant to be a user API
> for accessing the existing functionality of the existing ib_sa module. In
> particular, ib_sa and ib_usa provide a mechanism for other processes to share
> SA/SM notices and traps.
>
> As I mentioned earlier, the reason ib_sa acts as a single access point for
> SA/SM traps and notices is because traps and notices are sent to ports, not to
> queue pairs and not to processes. That means only one entity can be subscribed
> for notices and traps at any particular time, and must manage them, "sharing
> them out" among all processes that are interested in them.

Is this intended to handle multiple applications 
subscribing/unsubscribing for the same report ?

> Generalizing that to include other types of notices and traps would involve
> non-trivial changes to the ib_sa and might impact other parts of the infiniband
> subsystem, including the SM, since they would have to be rewritten to deal with
> the possibility that another component is now managing all notices and traps.
>
> Below you will find a proposed API for accessing the notifications
> functionality of the existing ib_sa and ib_usa modules. This is pretty much
> exactly what we are currently using, but since Sean has suggested rdma_cm is
> better suited for multi-casting, they have been omitted.
>
> Now, given that this API is stand-alone right now, it could still be added to
> either libibumad or to libibverbs - but I like Sean's suggestion that it be
> added to verbs, since the current security model restricts libibumad to root
> access and because the existing API already makes use of libibverbs'
> ibv_context data structure.
>
> ---------- current ib_usa API --------
>
> /* InformInfo:TrapNumber */
> enum {
>          IBV_SA_SM_TRAP_GID_IN_SERVICE              = __constant_cpu_to_be16(64),
>          IBV_SA_SM_TRAP_GID_OUT_OF_SERVICE          = __constant_cpu_to_be16(65),
>          IBV_SA_SM_TRAP_CREATE_MC_GROUP             = __constant_cpu_to_be16(66),
>          IBV_SA_SM_TRAP_DELETE_MC_GROUP             = __constant_cpu_to_be16(67),
>          IBV_SA_SM_TRAP_PORT_CHANGE_STATE           =
> __constant_cpu_to_be16(128),
>          IBV_SA_SM_TRAP_LINK_INTEGRITY              =
> __constant_cpu_to_be16(129),
>          IBV_SA_SM_TRAP_EXCESSIVE_BUFFER_OVERRUN    =
> __constant_cpu_to_be16(130),
>          IBV_SA_SM_TRAP_FLOW_CONTROL_UPDATE_EXPIRED =
> __constant_cpu_to_be16(131),

Why aren't traps 144 and 145 also defined ?

>          IBV_SA_SM_TRAP_BAD_M_KEY                   =
> __constant_cpu_to_be16(256),
>          IBV_SA_SM_TRAP_BAD_P_KEY                   =
> __constant_cpu_to_be16(257),
>          IBV_SA_SM_TRAP_BAD_Q_KEY                   =
> __constant_cpu_to_be16(258),
>          IBV_SA_SM_TRAP_ALL                         =
> __constant_cpu_to_be16(0xFFFF)
> };
>
> struct ibv_sa_event_channel;
> struct ibv_sa_event;
> struct ibv_sa_id;
>
> /**
>   * ibv_sa_create_event_channel - Open a channel used to report events.
>   */
> struct ibv_sa_event_channel *ibv_sa_create_event_channel();
>
> /**
>   * ibv_sa_destroy_event_channel - Close the event channel.
>   * @channel: The channel to destroy.
>   */
> void ibv_sa_destroy_event_channel(struct ibv_sa_event_channel *channel);
>
> /**
>   * ibv_sa_get_event - Retrieves the next pending event, if no event is
>   *   pending waits for an event.
>   * @channel: Event channel to check for events.
>   * @event: Allocated information about the next event.
>   *    Event should be freed using ibv_sa_ack_event()
>   */
> int ibv_sa_get_event(struct ibv_sa_event_channel *channel,
>                       struct ibv_sa_event **event);
>
> /**
>   * ibv_sa_ack_event - Free an event.
>   * @event: Event to be released.
>   *
>   * All events which are allocated by ibv_sa_get_event() must be released,
>   * there should be a one-to-one correspondence between successful gets
>   * and acks.
>   */
> int ibv_sa_ack_event(struct ibv_sa_event *event);
>
> /**
>   * ibv_sa_register_inform_info - Registers to receive notice events.
>   * @channel: Event channel to issue query on.
>   * @device: Device associated with record.
>   * @port_num: Port number of record.
>   * @trap_number: InformInfo trap number to register for, in network byte
>   *   order.

Nit: If trap_number is in network byte order, shouldn't it be ib_net16_t 
below ?

>   * @context: User specified context associated with the registration.
>   * @id: SA registration identifier.
>   *
>   * This call initiates a registration request with the SA for the specified
>   * trap number.  If the operation is started successfully, it returns
>   * an ibv_sa_id structure that is used to track the registration operation.
>   * Users must free this structure by calling ibv_sa_free_id.
>   *
>   * An event status of -ENETRESET indicates that an error occurred which
> requires * reregisteration.
>   */
> int ibv_sa_register_inform_info(struct ibv_sa_event_channel *channel,
>                                  struct ibv_context *device, uint8_t port_num,
>                                  uint16_t trap_number, void *context,
>                                  struct ibv_sa_id **id);

Shouldn't there be more granularity in this API in terms of what can be 
subscribed for ?  IMO trap number is insufficient for registration and 
this API should contain a trap specific variable with a component mask 
indicating what fields are valid in that variable.

Also, this API should be able to support registering for "all" traps.

> /**
>   * ibv_sa_free_id - Releases SA registration.
>   * @id: Registration tracking structure.
>   */
> int ibv_sa_free_id(struct ibv_sa_id *id);

What does releasing SA registration mean exactly ? Is it purely a local 
operation or does it also do the deregistration with the SA ? I can't 
tell for sure from the description above but suspect this API causes the 
SA deregistration to occur as well.

-- Hal
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
